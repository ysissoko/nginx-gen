#!/bin/sh

# generate a deploy key for each project and print it
for filepath in $(cat input.example.json | jq '.[].deployment.privKeyFilepath'); do
    ssh-keygen -t ed25519 -N -f $filepath
    cat "$filepath.pub"
done
