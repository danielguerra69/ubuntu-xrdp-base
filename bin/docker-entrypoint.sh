#!/bin/bash

# prepare the etc dir
if [ ! -f "/etc/entrypoint.d" ];
then
		cp -R /etc_entrypoint/* /etc/
fi

# read entrypoint.d configuration
for x in `find /etc/entrypoint.d -name '*.conf' | sort`;
do
		bash $x
done

exec "$@"
