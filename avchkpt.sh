#!/bin/sh

version="1.0"

echomsg ()
{
    echo `date +"%y.%m.%d %H:%M:%S"` ":" "$1"
}

av_checkpoint_create(){
    mccli_opts=" --override_maintenance_scheduler\=true"
    tsleep=30
    echomsg "Creating a checkpoint"
    curdate=`date -u +"%Y%m%d"`
    cmd="mccli checkpoint create $mccli_opts"
    echomsg "Running cmd: $cmd"
    eval "$cmd"
    echomsg "Waiting $tsleep seconds for the checkpoint to be created"
    sleep $tsleep
    cpname=`mccli checkpoint show | grep "^cp.$curdate.*No" | grep -v "Validated" | tail -1 | cut -d ' ' -f1`
    case "$cpname" in
        "")
            echomsg "No checkpoint found check avamar server processes"
            mccli checkpoint show
            exit 1
            ;;
    esac
    cmd="mccli checkpoint show"
    echomsg "Running cmd: $cmd"
    eval "$cmd"
    ##  made it here means we have a checkpoint to validate
    cmd="mccli checkpoint validate --cptag=$cpname $mccli_opts"
    echomsg "Validating the checkpoint $cpname"
    echomsg "Running cmd: $cmd"
    eval "$cmd"
    ## waiting for the checkpoint to get to In Progress state
    echomsg "Waiting for the validation to start..."
    cpstate=`mccli checkpoint show | grep "$cpname.*In Progress"`
    while [ "$cpstate" = "" ]
    do
	cpstate=`mccli checkpoint show | grep "$cpname.*In Progress"`
    done

    cpstate=`mccli checkpoint show | grep "$cpname.*In Progress"`
    while [ "$cpstate" != "" ]
    do
	echomsg "Found $cpstate"
	cpstate=`mccli checkpoint show | grep "$cpname.*In Progress"`
    done
    cmd="mccli checkpoint show | grep $cpname"
    echomsg "Running cmd : $cmd"
    eval "$cmd"
}

##main()

echomsg "$0 version: $version"
case $1 in 
    "--list")
	mccli checkpoint show
	;;
    "--create")
	num=1
	if [ ! -z $2 ]
	then 
	    echo here
	    num=$2
	fi
	while (($num > 0 ))
	do
	    av_checkpoint_create
            num=$(($num - 1))
        done
	cmd="mccli checkpoint show"
	echomsg "Running cmd: $cmd"
	eval "$cmd"
	;;
    *)
	echo "usage --list | --create [1 | 2]"
	echo "   --list - list current checkpoints"
        echo "   --create - create 1 or 2 checkpoints (default is 1 checkpoint)"
        exit 0
        ;;
esac

echomsg "All done"

