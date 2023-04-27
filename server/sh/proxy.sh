#! /bin/bash

mitmweb &
mitmpid=$!

docker compose run --rm server
exit_status=$?

kill $mitmpid
exit $exit_status
