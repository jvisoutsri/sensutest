#!/bin/bash

# #RED
SCHEME=`hostname`

usage()
{
  cat <<EOF
usage: $0 options

This plugin produces the total number of zombie processes

OPTIONS:
   -h      Show this message
   -s      Metric naming scheme
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


get_total_zombie_proc()
{
        zombieProc=$(ps -A -ostat,ppid |  awk '/[zZ]/{print $2}' | wc -l)
        #zombieProcFinal=$(expr $zombieProc - 2)
}

get_total_zombie_proc

echo "$SCHEME.zombieProcesses $zombieProc `date +%s`"



