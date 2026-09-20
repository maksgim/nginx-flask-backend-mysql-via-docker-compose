#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$HOME/db-backups}"
KEEP=7
STAMP="$(date +%F_%H-%M)"
FILE="$BACKUP_DIR/appdb_$STAMP.sql.gz"

cleanup() { rm -f "$FILE.tmp"; }
trap cleanup EXIT

echo "[$(date '+%F %T')] backup start"
mkdir -p "$BACKUP_DIR"
cd "$PROJECT_DIR"          # compose определяет проект по папке

docker compose exec -T mysql sh -c \
  'MYSQL_PWD="$MYSQL_ROOT_PASSWORD" mysqldump -uroot --single-transaction --routines appdb' \
  | gzip > "$FILE.tmp"

# проверка: дамп дошёл до конца, а не оборвался
zcat "$FILE.tmp" | grep -q "Dump completed" || { echo "ERROR: dump incomplete"; exit 1; }
mv "$FILE.tmp" "$FILE"
echo "saved: $FILE ($(du -h "$FILE" | cut -f1))"

# ротация: оставить последние $KEEP
ls -1t "$BACKUP_DIR"/appdb_*.sql.gz | tail -n +$((KEEP + 1)) | xargs -r rm --

# отправка в git, если каталог бэкапов это репозиторий
if [ -d "$BACKUP_DIR/.git" ]; then
  cd "$BACKUP_DIR"
  git add -A
  git diff --cached --quiet || git commit -m "backup $STAMP"
  git push
  echo "pushed to git"
fi
echo "[$(date '+%F %T')] backup done"
