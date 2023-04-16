import os
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel
import wandb

app = FastAPI()

@app.get("/")
def read_root():
    return {"Welcome! This is a simple app to allow wandb logging from non-supported languages."}

class Init(BaseModel):
    project: str
    notes: str
    tags: Union[str, list[str]]
    config: dict

@app.get("/wandb/init")
def wandb_init(init: Init):
    if wandb.run is not None:
        wandb.finish()

    wandb.init(
        project=init.project,
        notes=init.notes,
        tags=init.tags,
        config=init.config
    )

class Log(BaseModel):
    metrics: dict

@app.get("/wandb/log")
def wandb_log(log: Log):
    wandb.log(log.metrics)
