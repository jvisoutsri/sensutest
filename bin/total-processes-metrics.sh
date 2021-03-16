#!/bin/bash

# #RED
SCHEME=`hostname`

usage()
{
  cat <<EOF
usage: $0 options

This plugin produces total number of processes

OPTIONS:
   -h      Show this message
   -s      Metric naming scheme, text to prepend to cpu.usage (default: $SCHEME)
EOF
}

while getopts "h:s:" OPTION
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




get_total_proc()
{
	procFinal=$(ps -elf | wc -l)
	#procFinal=expr $((proInit - 1))
	
	#echo $procInit
	#echo $procFinal
}

get_total_proc


echo "$SCHEME.total_procs $(expr $procFinal - 4) `date +%s`"


