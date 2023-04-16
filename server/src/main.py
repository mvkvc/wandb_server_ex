from fastapi import FastAPI, Body
from pydantic import BaseModel
from typing import Union, List, Any
import wandb

app = FastAPI()

# runs = {}


class Init(BaseModel):
    config: dict
    project: str
    notes: Union[str, None] = None
    tags: Union[str, List[str], None] = None


class Log(BaseModel):
    metrics: dict
    step: Union[int, None] = None
    # id: str
    # project: str


# class Finish(BaseModel):
#     id: str
#     project: str


@app.post("/wandb/init")
def wandb_init(init: Init = Body(...)) -> dict[str, Any]:
    # if init.project not in runs:
    #     runs[init.project] = {}
    if wandb.run:
        wandb.finish()

    # run = wandb.init(
    #     project=init.project, notes=init.notes, tags=init.tags, config=init.config
    # )
    wandb.init(
        project=init.project, notes=init.notes, tags=init.tags, config=init.config
    )

    # run_id = run.id
    # runs[init.project][run_id] = run

    # return {"id": run_id}
    return {"success": True}


@app.post("/wandb/log")
def wandb_log(log: Log = Body(...)) -> dict[str, Any]:
    # if log.id in runs[log.project]:
    #     runs[log.project][log.id].log(log.metrics)
    # return {"success": True}
    # else:
    #     return {"success": False, "error": "Run ID not found"}
    if not wandb.run:
        return {"success": False, "error": "No run found"}

    wandb.log(log.metrics)
    return {"success": True}


@app.post("/wandb/finish")
def wandb_finish() -> dict[str, Any]:
    # if finish.id in runs[finish.project]:
    #     runs[finish.project][finish.id].finish()
    #     del runs[finish.project][finish.id]
    #     return {"success": True}
    # else:
    #     return {"success": False, "error": "Run ID not found"}
    if not wandb.run:
        return {"success": False, "error": "No run found"}

    wandb.finish()
    return {"success": True}


# @app.get("/wandb/runs")
# # def wandb_runs() -> dict[str, dict[str, Any]]:
# def wandb_runs() -> dict[str, str]:
#     print(runs)
#     runs_dict = {}
#     if runs:
#         for project, runs_obj in runs.items():
#             runs_dict[project] = list(runs_obj.keys())

#     print(runs_dict)
#     # return {"runs": runs_dict}
#     return {"runs": "ok"}
