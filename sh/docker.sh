#! /bin/bash

sh/reqs.sh
docker build -t mvkvc/wandb_server:latest .
