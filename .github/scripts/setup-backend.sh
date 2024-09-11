#!/bin/bash

LOCAL_FOLDER=$(echo "$1" | xargs)
REGION=$(echo "$2" | xargs)
PROJECT_BUCKET_NAME=$(echo "$3" | xargs)
SUB_PROJECT_NAME=$(echo "$4" | xargs)

cat <<EOF > "./${LOCAL_FOLDER}/backend.tfvars"
region = "${REGION}"
bucket = "${PROJECT_BUCKET_NAME}"
key    = "remote_states/${SUB_PROJECT_NAME}/terraform.tfstate"
EOF

cat "./${LOCAL_FOLDER}/backend.tfvars"
