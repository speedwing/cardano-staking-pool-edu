#!/usr/bin/env bash

while true ; do
  ./topologyUpdater || 0
  sleep 3600
done
