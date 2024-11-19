#!/bin/sh

# This script generate a wildcard subdomain TLS certificate for the specified subdomain
if [ -z $1 ]; then 
    echo "Please specify a subdomain to generate the certs\nUsage: gen_certs.sh <subdomain>\n" 
    exit 1
else
    domain=$1
    apt install certbot python3-certbot-nginx -y
    certbot certonly --manual --preferred-challenges=dns --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.$domain
fi
