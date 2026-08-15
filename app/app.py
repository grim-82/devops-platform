import logging
import os
import time

from flask import Flask, jsonify, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST


app = Flask(__name__)

logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(message)s"
)

logger = logging.getLogger(__name__)

APP_NAME = os.getenv("APP_NAME", "devops-platform")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
START_TIME = time.time()

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "endpoint"]
)


@app.route("/")
def index():
    REQUEST_COUNT.labels(method="GET", endpoint="/").inc()

    logger.info("Request received: GET /")

    return jsonify(
        application=APP_NAME,
        version=APP_VERSION,
        status="running"
    )


@app.route("/health")
def health():
    REQUEST_COUNT.labels(method="GET", endpoint="/health").inc()

    return jsonify(status="healthy")


@app.route("/ready")
def ready():
    REQUEST_COUNT.labels(method="GET", endpoint="/ready").inc()

    return jsonify(status="ready")


@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )


@app.route("/info")
def info():
    uptime_seconds = int(time.time() - START_TIME)

    return jsonify(
        application=APP_NAME,
        version=APP_VERSION,
        uptime_seconds=uptime_seconds
    )


if __name__ == "__main__":
    logger.info(
        "Starting application name=%s version=%s",
        APP_NAME,
        APP_VERSION
    )

    app.run(
        host="0.0.0.0",
        port=8080
    )
