#!/bin/bash
helm upgrade --install -n observe prom-stack . -f values-rpi.yaml
