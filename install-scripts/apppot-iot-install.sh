#!/bin/bash

# AppPot Iot Install Script

# usage
usage_exit() {
    echo "Usage: $0 [-d install_dir] [-s zipfile] [-o owner]" 1>&2
        exit 1
}

# default value
DIST_DIR="/opt"
ACTIVEMQ="apache-activemq-5.14.0-bin.zip"
KAFKA="kafka_2.10-0.10.0.1.tgz"
SOURCE_FILE="apppot-iot.zip"
OWN="apppot"
BASE_DIR="../../resource"

# get opts
while getopts d:s:o:h OPT
do
    case $OPT in
        d)  DIST_DIR=$OPTARG
            ;;
        s)  SOURCE_FILE=$OPTARG
            ;;
        o)  OWN=$OPTARG
            ;;
        h)  usage_exit
            ;;
    esac
done
shift $((OPTIND - 1))

# main
cd $BASE_DIR

[ -d $DIST_DIR ] || mkdir -p $DIST_DIR
unzip $SOURCE_FILE -d $DIST_DIR

cd $DIST_DIR/apppot-iot/middleware

unzip $ACTIVEMQ -d $DIST_DIR/apppot-iot
tar xzf $KAFKA -C $DIST_DIR/apppot-iot

chmod -R 774 $DIST_DIR/apppot-iot
chown -R $OWN:$OWN $DIST_DIR/apppot-iot
exit 1
