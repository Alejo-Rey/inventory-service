#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

bundle exec rails db:migrate

# exec the command sent in docker compose
exec "$@"
