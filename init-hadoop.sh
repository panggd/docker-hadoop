#!/bin/sh
git clone https://github.com/big-data-europe/docker-hadoop.git
cd docker-hadoop
docker-compose up -d # -d flag to start as background task