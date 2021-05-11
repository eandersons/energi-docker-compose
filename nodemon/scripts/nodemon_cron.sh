#!/bin/bash
while :
do
    /bin/bash nodemon.sh cron && {
        sleep ${ECNM_INTERVAL:-'10m'}
    } || {
        echo "Exiting Energi Core Node Monitor container cron because of an error."
        echo "Please see the output above for details!"
        break
    }
done
