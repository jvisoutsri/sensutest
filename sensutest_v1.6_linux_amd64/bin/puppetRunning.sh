#!/bin/bash

if pgrep -x "puppet" > /dev/null
then
	echo "OK - Puppet is running on $HOSTNAME"
	exit 0
else
	echo "CRITICAL - Puppet is NOT running on $HOSTNAME. If puppet should not be running for a reason, please let the team know. Check with the team before starting puppet."
	exit 2
fi
