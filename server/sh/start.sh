#! /bin/bash

# docker run -it --rm --env-file .env --network host mvkvc/wandb_server:latest
docker run -it --rm --env-file .env -p 5678:5678 mvkvc/wandb_server:mitm
