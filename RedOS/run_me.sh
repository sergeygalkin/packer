#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -rf output

packer init .
packer build .
