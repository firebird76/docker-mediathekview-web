#!/usr/bin/env bash
docker compose build 
docker compose push
docker system prune -a -f
