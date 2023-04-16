#! /bin/bash

if [ -z "$WANDB_ENTITY" ] || [ "$WANDB_ENTITY" == "" ] || [ "$WANDB_API_KEY" == "" ]; then
    echo "Please set the environment variables: WANDB_ENTITY, WANDB_PROJECT, WANDB_API_KEY"
    exit 1
fi

if [ -z "$WANDB_PORT" ] || [ "$WANDB_PORT" == "" ]; then
    PORT=5678
fi

uvicorn src.main:app --reload --host --port $PORT
