#!/bin/bash

# #RED
SCHEME=`hostname`

usage()
{
  cat <<EOF
usage: $0 options

This plugin produces number of users currently logged in

OPTIONS:
   -h      Show this message
   -p      PID
   -f      Path to PID file
   -s      Metric naming scheme, text to prepend to cpu.usage (default: $SCHEME)
EOF
}

while getopts "hp:f:s:" OPTION
  do
    case $OPTION in
      h)
        usage
        exit 1
        ;;
      p)
        PID="$OPTARG"
        ;;
      s)
        SCHEME="$OPTARG"
        ;;
      f)
        PIDFILE="$OPTARG"
        ;;
      ?)
        usage
        exit 1
        ;;
    esac
done

get_current_users_count()
{
	whoVar=$(who --count)
	
	for i in $whoVar; do
     	if  [[ "$i" == "users"* ]]; then
     		getUserCountStr=($i)
     		break
     	fi
	done
	
	getUserCount=${getUserCountStr:6:6}
	
	
}

  sleep 1

get_current_users_count

echo "$SCHEME.user.count $getUserCount `date +%s`"
