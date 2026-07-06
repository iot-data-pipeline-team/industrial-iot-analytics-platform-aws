import json
import random
import time

from datetime import datetime, timezone
from itertools import cycle

from msk_producer import producer



TOPIC_NAME = "worker-events"


WORKERS = [
    {
        "worker_id": "W001",
        "floor": "A",
        "zone_id": "ZONE_1"
    },
    {
        "worker_id": "W002",
        "floor": "B",
        "zone_id": "ZONE_2"
    },
    {
        "worker_id": "W003",
        "floor": "C",
        "zone_id": "ZONE_3"
    },
    {
        "worker_id": "W004",
        "floor": "A",
        "zone_id": "ZONE_1"
    }
]


def generate_worker_event(worker):

    fatigue = random.randint(10, 100)

    heart_rate = random.randint(60, 130)

    if random.random() < 0.01:
        heart_rate = -20

    if fatigue > 80:
        danger_zone = random.random() < 0.30
    else:
        danger_zone = random.random() < 0.10

    helmet_on = random.random() > 0.05

    safety_vest_on = random.random() > 0.08

    movement_status = random.choice([
        "ACTIVE",
        "IDLE",
        "WALKING"
    ])

    if random.random() < 0.01:
        movement_status = "FLYING"

    if random.random() < 0.01:
        timestamp = None
    else:
        timestamp = datetime.now(
            timezone.utc
        ).isoformat()   

    worker_id = worker["worker_id"]

    if random.random() < 0.01:
        worker_id = ""         

    return {
        "worker_id": worker_id,

        "timestamp": timestamp,

        "floor": worker["floor"],

        "zone_id": worker["zone_id"],

        "helmet_on": helmet_on,

        "safety_vest_on": safety_vest_on,

        "heart_rate": heart_rate,

        "movement_status": movement_status,

        "danger_zone": danger_zone,

        "fatigue_score": fatigue
    }




worker_cycle = cycle(WORKERS)

while True:

    worker = next(worker_cycle)

    event = generate_worker_event(worker)

    producer.produce(
        topic=TOPIC_NAME,
        key=event["worker_id"] or "UNKNOWN",
        value=json.dumps(event)
    )

    producer.flush()

    print(
        f"Worker={event['worker_id']} "
        f"HeartRate={event['heart_rate']} "
        f"Fatigue={event['fatigue_score']} "
        f"Danger={event['danger_zone']}"
    )
    
    time.sleep(1)