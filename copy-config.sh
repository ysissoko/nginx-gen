#!/bin/bash

mv output/nginx.conf /etc/nginx/conf.d/
mv output/config ~/.ssh/

sudo systemctl reload ssh
nginx -t
sudo systemctl reload nginx

