#!/usr/bin/env sh

set -ex

unseal () {
vault operator unseal $(grep 'Key 1:' /vault/_key-token/keys | awk '{print $NF}')
vault operator unseal $(grep 'Key 2:' /vault/_key-token/keys | awk '{print $NF}')
vault operator unseal $(grep 'Key 3:' /vault/_key-token/keys | awk '{print $NF}')
}

init () {
vault operator init > /vault/_key-token/keys
}

log_in () {
   export ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/_key-token/keys | awk '{print $NF}')
   vault login $ROOT_TOKEN
}

create_token () {
   vault token create -id $MY_VAULT_TOKEN
}

if [ -s /vault/_key-token/keys ]; then
   unseal
else
   init
   unseal
   log_in
   create_token
fi

vault status > /vault/file/status