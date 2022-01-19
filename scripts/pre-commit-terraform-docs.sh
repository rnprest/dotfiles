#!/bin/bash

# regenerate terraform documentation
terraform-docs markdown table \
    . \
    --header-from .header.md \
    --show header \
    --show modules \
    --show resources \
    --show data-sources \
    --hide-empty \
    --output-file README.md
