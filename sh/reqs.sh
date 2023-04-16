#! /bin/bash

poetry lock --no-update
poetry export -f requirements.txt --output requirements.txt
