#!/bin/sh
# A helper script to do a one time setup to use `energi3-docker-compose`
data_directory=.energicore3
keystore_path=${data_directory}/keystore
user=nrgstaker
home=/home/${user}
staker_keystore_path=${home}/${keystore_path}

mkdir --parent ${staker_keystore_path}
mv /setup/${keystore_path}/* ${staker_keystore_path}/
chown -R ${user}:${user} ${home}/${data_directory}
