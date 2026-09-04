import os
from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)
app.json.ensure_ascii = False  # чтобы кириллица не превращалась в \u0440\u0430...

@app.route("/")
def users():
    db = mysql.connector.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"]
    )
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT id, name FROM users")
    result = cursor.fetchall()

    cursor.close()
    db.close()
    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)