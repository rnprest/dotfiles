#!/bin/bash

rg "your search term" -g "!bisect-check.sh" && exit 1
exit 0
