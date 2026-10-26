# Revirathya - Infrastructure

## Overview

Infrastructure definitions for Revirathya projects

## Setup

For `kind-dev`. Make sure to generate
```sh
# 1. Copy and update value on Postgres Finance credentials
cp clusters/kind-dev/postgres/components/finance/credentials.example.yaml \
    clusters/kind-dev/postgres/components/finance/credentials.yaml

# 2. Copy and update value on credentials Finance database credentials.
# Make sure the value is equal to Postgres Finance credentials
cp clusters/kind-dev/finance/components/secrets/database-credentials.example.yaml \
    clusters/kind-dev/finance/components/secrets/database-credentials.yaml

# 3. Copy and update value on credentials Finance service credentials.
cp clusters/kind-dev/finance/components/secrets/service-credentials.example.yaml \
    clusters/kind-dev/finance/components/secrets/service-credentials.yaml

# 4. Up the service (recommend using Makefile)
make database-apply
make finance-apply
```
