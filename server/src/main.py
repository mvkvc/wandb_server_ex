from fastapi import FastAPI, Body
from pydantic import BaseModel
from typing import Union, List, Any
import wandb

app = FastAPI()

class Init(BaseModel):
    config: dict
    project: str
    notes: Union[str, None] = None
    tags: Union[str, List[str], None] = None


class Log(BaseModel):
    metrics: dict
    step: Union[int, None] = None

@app.post("/wandb/init")
def wandb_init(init: Init = Body(...)) -> dict[str, Any]:
    if wandb.run:
        wandb.finish()

    wandb.init(
        project=init.project, notes=init.notes, tags=init.tags, config=init.config
    )

    return {"success": True}


@app.post("/wandb/log")
def wandb_log(log: Log = Body(...)) -> dict[str, Any]:
    if not wandb.run:
        return {"success": False, "error": "No run found"}

    wandb.log(log.metrics, log.step)
    return {"success": True}


@app.post("/wandb/finish")
def wandb_finish() -> dict[str, Any]:
    if not wandb.run:
        return {"success": False, "error": "No run found"}

    wandb.finish()
    return {"success": True}
