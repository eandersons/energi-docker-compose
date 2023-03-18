#!/bin/sh
# A script to apply preimages for a Energi Core Node container
# https://docs.energi.software/en/core-node-troubleshoot#preimage
# The command `rm preimages.rlp` may throw an error (it does not affect the outcome) as `preimages.rlp` might not exist.
. ./energi_command.sh
rm preimages.rlp
wget https://s3-us-west-2.amazonaws.com/download.energi.software/releases/chaindata/mainnet/preimages.rlp
${energi_command} import-preimages preimages.rlp
