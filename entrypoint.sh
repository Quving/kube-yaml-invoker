#!/bin/bash

set -e

FILE_TEMPLATE='/tmp/manifest.yaml.template'
FILE_MANIFEST='/tmp/manifest.yaml'

# Check if environment variable $KUBECONFIG is set
if [ -z "$KUBECONFIG_DATA" ]; then
  echo "Environment variable KUBECONFIG is not set. Exiting."
  exit 1
fi

# Check if environment variable $KUBERNETES_MANIFEST_DATA is set
if [ -z "$MANIFEST_DATA" ]; then
  echo "Environment variable KUBERNETES_MANIFEST_DATA is not set. Exiting."
  exit 1
fi

# Decode and write environment variable $KUBECONFIG to file
mkdir -p $HOME/.kube
echo "$KUBECONFIG_DATA" | base64 -d > $HOME/.kube/config

# Decode and write environment variable $MANIFEST_DATA to file
echo "$MANIFEST_DATA" | base64 -d > $FILE_TEMPLATE

# Test if manifest can be rendered.
# If not, script will exit with error 1. Else it will continue.
bash validate_template_rendering.sh $FILE_TEMPLATE

# Replace variables in manifest
envsubst < $FILE_TEMPLATE > $FILE_MANIFEST

# Invoke command
kubectl apply -f $FILE_MANIFEST
