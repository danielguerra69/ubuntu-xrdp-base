#!/bin/bash

# read entrypoint.d configuration
for x in `find /etc/entrypoint.d -name '*.conf' | sort`;
do
		bash $x
done

exec "$@"
