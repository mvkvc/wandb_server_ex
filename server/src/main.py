from fastapi import FastAPI, Body
from pydantic import BaseModel
from typing import Union, List, Any
import wandb
import os
import requests
from dotenv import load_dotenv

load_dotenv()

class Init(BaseModel):
    config: dict
    project: str
    notes: Union[str, None] = None
    tags: Union[str, List[str], None] = None


class Log(BaseModel):
    metrics: dict
    step: Union[int, None] = None

import certifi
print(certifi.where())

session = requests.Session()
session.proxies = {
   'http': 'http://127.0.0.1:8080',
   'https': 'http://127.0.0.1:8080',
}

app = FastAPI()

@app.post("/wandb/init")
def wandb_init(init: Init = Body(...)) -> dict[str, Any]:
    response = {"success": True}
    if wandb.run:
        wandb.finish()

    wandb.init(
        project=init.project, notes=init.notes, tags=init.tags, config=init.config
    )

    return response


@app.post("/wandb/log")
def wandb_log(log: Log = Body(...)) -> dict[str, Any]:
    response = {"success": True}
    if not wandb.run:
        response["success"] = False
        return response

    wandb.log(log.metrics, log.step)
    return response


@app.post("/wandb/finish")
def wandb_finish() -> dict[str, Any]:
    response = {"success": True}
    if not wandb.run:
        return response

    wandb.finish()
    return response
