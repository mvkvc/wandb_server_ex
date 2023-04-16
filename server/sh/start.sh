#! /bin/bash

docker run -it --rm --env-file .env --network host mvkvc/wandb_server:latest
