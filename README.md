# Docker Compose — Nginx + Backend + MySQL

Мой первый учебный проект по Linux, Docker и Docker Compose.

## Архитектура

Проект состоит из трёх контейнеров:

- **Nginx** — принимает HTTP-запросы на порту `8080` и проксирует их на backend.
- **Backend** — Python-приложение, собираемое из собственного Dockerfile.
- **MySQL 8.0** — база данных с постоянным хранением данных через Docker volume.

Все сервисы работают в общей Docker-сети.

```text
Client
  │
  │ :8080
  ▼
Nginx
  │
  │ backend:5000
  ▼
Backend
  │
  │ MySQL
  ▼
MySQL 8.0
Что использовано
Debian Linux
Docker
Docker Compose
Nginx
Python
MySQL 8.0
Docker volumes
Docker networks
Healthcheck
depends_on
Git
Структура проекта
.
├── compose.yaml
├── default.conf
├── .gitignore
└── backend/
    ├── app.py
    └── Dockerfile
Запуск проекта
Перейти в директорию проекта:
cd ~/docker/nginx
Запустить контейнеры:
docker compose up -d
Проверить состояние:
docker compose ps
MySQL должен иметь статус:
healthy


Проверка конфигурации

Перед запуском можно проверить итоговую конфигурацию Compose:
docker compose config
Полное пересоздание

Остановить и удалить контейнеры:
docker compose down

Запустить проект заново:
docker compose up -d
Данные MySQL сохраняются в Docker volume и не удаляются обычной командой docker compose down.

Диагностика
Логи отдельного сервиса:
docker compose logs nginx
docker compose logs backend
docker compose logs mysql

Список контейнеров:
docker ps

Информация о контейнере:
docker inspect <container>

Просмотр процессов контейнера:
docker top <container>

Healthcheck
Для MySQL настроена проверка готовности:
mysql → SELECT 1 → healthy
Backend зависит от готовности MySQL.
Это позволяет не запускать backend до того, как база данных будет готова принимать подключения.
Постоянное хранение данных
MySQL использует Docker volume:
mysql_data
Поэтому удаление контейнера MySQL не приводит к автоматическому удалению данных базы.

Цель проекта

Проект создан как практическая работа для изучения:
Linux
Docker
Docker Compose
сетевого взаимодействия контейнеров
reverse proxy
диагностики контейнеров
healthcheck
persistent storage
Git
