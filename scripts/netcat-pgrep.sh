#!/bin/sh
IFS= read -r args
eval /usr/bin/pgrep "${args}"
