import requests
import random
import time
import json


def init(config: dict, project: str, port: int = 5678):
    headers = {"Content-type": "application/json"}
    response = requests.post(
        url=f"http://127.0.0.1:{port}/wandb/init",
        data=json.dumps({"config": config, "project": project}),
        headers=headers,
    )

    return response.json()


# def log(metrics: dict, id: str, project: str = "testserver", port: int = 5678):
#     headers = {"Content-type": "application/json"}
#     response = requests.post(
#         url=f"http://127.0.0.1:{port}/wandb/log",
#         data=json.dumps({"metrics": metrics, "id": id, "project": project}),
#         headers=headers,
#     )

#     return response.json()


def log(metrics: dict, port: int = 5678):
    headers = {"Content-type": "application/json"}
    response = requests.post(
        url=f"http://127.0.0.1:{port}/wandb/log",
        data=json.dumps({"metrics": metrics}),
        headers=headers,
    )

    return response.json()


def finish(port: int = 5678):
    # headers = {"Content-type": "application/json"}
    response = requests.post(
        url=f"http://127.0.0.1:{port}/wandb/finish",
        # data=json.dumps({"id": id, "project": project}),
        # headers=headers,
    )

    return response.json()


# def runs(port: int = 5678):
#     response = requests.get(url=f"http://127.0.0.1:{port}/wandb/runs")

#     return response.json()


if __name__ == "__main__":

    def rand_metrics():
        return {
            "loss": random.random(),
            "acc": random.random(),
        }

    project = "testserver"
    config = {"lr": 0.01, "epochs": 10, "batch_size": 32}

    print("Starting run")
    init(config=config, project=project)
    for i in range(5):
        time.sleep(1)
        print(f"Logging metrics iter {i}")
        log(metrics=rand_metrics())

    print("Finishing run")
    finish()
