#!/usr/bin/env bash

while true ; do
  /usr/local/bin/topologyUpdater.sh || 0
  sleep 3600
done
