#!/bin/bash

export DAGSTER_HOME=/opt/dagster
export DAGSTER_DIR=/var/lib/mad/dagster

# dagster
cd ${DAGSTER_DIR} && dagit -h 0.0.0.0 -p 3070 &

# Entrypoint, for example notebook
if [[ $# -gt 0 ]] ; then
    eval "$1"
fi
