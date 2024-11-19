#!/bin/bash

# Load Github personal access token
source .env

input_json=$1

# Validate JSON
if ! [ -f "$input_json" ]; then
    echo "Input JSON file not found: $input_json"
    exit 1
fi

# Get the total number of elements in the JSON array
num_entries=$(jq 'length' $input_json)

if [ "$num_entries" -eq 0 ]; then
    echo "No entries in the JSON file."
    exit 0
fi

function set_deploy_key() {
    key=$1 
    owner=$2 
    repo=$3 
    token=$4

    echo "key: $key - owner: $owner - repo: $repo - token: $token"

    # Check if the key already exists
    existing_key=$(curl -s -H "Authorization: token $token" \
    -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/$owner/$repo/keys | \
    jq --arg key "$key" '.[] | select(.key == $key)')

    if [ -z "$existing_key" ]; then
        echo "Key not found. Adding new deploy key..."
        curl -s -X POST -H "Authorization: token $token" \
            -H "Accept: application/vnd.github+json" \
            -d @- https://api.github.com/repos/$owner/$repo/keys <<EOF
        {
        "title": "vps deploy key",
        "key": "$key",
        "read_only": true
        }
EOF
    else
        echo "Key already exists. Skipping..."
    fi
}

echo "Deploy keys generation..."

# generate a deploy key for each project and print it
for ((i = 0; i < num_entries; i++)); do
    # Extract the 'privKeyFilename' and 'name' fields for the current index
    filename=$(jq -r ".[$i].deployment.privKeyFilename" $input_json)
    repo=$(jq -r ".[$i].deployment.repo" $input_json)
    owner=$(jq -r ".[$i].deployment.owner" $input_json)
    name=$(jq -r ".[$i].name" $input_json)
    echo "filename: $filename, repo: $repo, owner: $owner, name: $name"
    # if key exists continue
    if [ -f ~/.ssh/$filename ]; then 
	    echo "private key already exist ~/.ssh/$filename skipping..."
	    continue
    fi
    
    ssh-keygen -t ed25519 -f ~/.ssh/$filename -q -P ""
    pubkey=$(cat ~/.ssh/$filename.pub)

    echo "Pubkey to deploy app $name: $pubkey"
    set_deploy_key "$pubkey" "$owner" "$repo" "$GH_TOKEN"
done

