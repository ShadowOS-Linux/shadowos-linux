#!/usr/bin/env bash

if [ "${USE_HV:-0}" = "1" ]; then
    export LD_PRELOAD="${LD_PRELOAD:+$LD_PRELOAD:}liblinuwux.so"
fi
