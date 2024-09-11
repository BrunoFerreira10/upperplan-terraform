#!/bin/bash

LOCAL_FOLDER=$(echo "$1" | xargs)
REGION=$(echo "$2" | xargs)
TAG_AUTHOR=$(echo "$3" | xargs)
TAG_CUSTOMER=$(echo "$4" | xargs)
TAG_PROJECT=$(echo "$5" | xargs)


cat <<EOF > "./${LOCAL_FOLDER}/providers.tf"
provider "aws" {
  region = "${REGION}"
  default_tags {
    tags = {
      "owner"      = "${TAG_AUTHOR}"
      "customer"   = "${TAG_CUSTOMER}"
      "project"    = "${TAG_PROJECT}"
      "managed-by" = "terraform"
    }
  }
}
EOF

cat "./${LOCAL_FOLDER}/providers.tf"
