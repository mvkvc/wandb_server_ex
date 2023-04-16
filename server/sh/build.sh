#! /bin/bash

sh/reqs.sh
docker build --no-cache -t mvkvc/wandb_server:latest .
