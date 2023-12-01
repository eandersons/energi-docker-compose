#!/bin/sh
IFS= read -r args
eval /bin/ps "${args}"
