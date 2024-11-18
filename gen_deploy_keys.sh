#!/bin/sh

# Load Github personal access token
source .env

repo_owner=ysissoko

input_json=$1
# Get the total number of elements in the JSON array
num_entries=$(jq 'length' $input_json)

# generate a deploy key for each project and print it
for ((i = 0; i < num_entries; i++)); do
    # Extract the 'privKeyFilename' and 'name' fields for the current index
    filename=$(jq -r ".[$i].deployment.privKeyFilename" $input_json)
    name=$(jq -r ".[$i].name" $input_json)

    # if key exists continue
    [ -f ~/.ssh/$filename ] && continue

    ssh-keygen -t ed25519 -f ~/.ssh/$filename -q -P ""
    pubkey=$(cat ~/.ssh/$filename.pub)

    echo "Pubkey to deploy app $name: $pubkey"
done
