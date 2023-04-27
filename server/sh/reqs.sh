#! /bin/bash

poetry lock --no-update
poetry export -f requirements.txt --without-hashes --output requirements.txt
