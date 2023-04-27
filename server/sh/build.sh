#! /bin/bash

sh/reqs.sh
# docker build --no-cache -t mvkvc/wandb_server:latest .
docker build --no-cache --progress=plain -t mvkvc/wandb_server:mitm .
