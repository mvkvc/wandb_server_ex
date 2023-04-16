#! /bin/bash

set -a
source .env
set +a

if [ -z "$WANDB_ENTITY" ] || [ "$WANDB_API_KEY" == "" ]; then
    echo $WANDB_ENTITY
    echo $WANDB_API_KEY
    echo "Please set the environment variables: WANDB_ENTITY, WANDB_API_KEY"
    exit 1
fi

if [ -z "$WANDB_PORT" ] || [ "$WANDB_PORT" == "" ]; then
    PORT=5678
else
    PORT=$WANDB_PORT
fi

uvicorn src.main:app --port "$PORT"
