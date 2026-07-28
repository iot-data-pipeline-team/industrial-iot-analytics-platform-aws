import socket
from confluent_kafka import Producer

BOOTSTRAP_SERVERS = (
    "localhost:19092,"
    "localhost:19093,"
    "localhost:19094"
)

producer = Producer({
    "bootstrap.servers": BOOTSTRAP_SERVERS,
    "client.id": socket.gethostname(),
})