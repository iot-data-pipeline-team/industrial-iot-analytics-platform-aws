import socket

from confluent_kafka import Producer
from aws_msk_iam_sasl_signer import MSKAuthTokenProvider
from aws_msk_iam_sasl_signer import MSKAuthTokenProvider


BOOTSTRAP_SERVERS = (
    "boot-vpgxsmnj.c3.kafka-serverless.us-east-1.amazonaws.com:9098"
)



def oauth_cb(oauth_config):
    token, expiry_ms = MSKAuthTokenProvider.generate_auth_token("us-east-1")
    return token, expiry_ms / 1000


producer = Producer(
    {
        "bootstrap.servers": BOOTSTRAP_SERVERS,
        "security.protocol": "SASL_SSL",
        "sasl.mechanisms": "OAUTHBEARER",
        "oauth_cb": oauth_cb,
        "client.id": socket.gethostname(),
    }
)