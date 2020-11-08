#!/usr/bin/env bash

while true ; do
  topologyUpdater.sh || 0
  sleep 3600
done
