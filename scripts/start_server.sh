#!/bin/bash
cd desarrollo-alt-f4-back
docker-compose stop
docker-compose build
docker-compose exec web bin/rails db:create db:migrate db:seed
docker-compose up -d