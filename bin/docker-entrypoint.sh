#!/bin/bash

# prepare the etc dir
cp -R /etc_entrypoint/* /etc/

# read entrypoint.d configuration
for x in `find /etc/entrypoint.d -name '*.conf' | sort`;
do
		bash $x
done

exec "$@"
