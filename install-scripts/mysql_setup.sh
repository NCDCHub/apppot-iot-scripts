#!/bin/bash

# usage
usage_exit() {
    echo "Usage: $0 [-u user] [-p password] [-s script_dir]" 1>&2
        exit 1
}

# default value
EXEC_USER="root"
EXEC_PASSWORD="root"
USER="apppotiot"
PASSWORD="apppotiot"
DATABASE_NAME="apppotiot"
#SCRIPT_DIR=`echo $(cd $(dirname -- $0) && pwd)`
SCRIPT_DIR="./installer/mysql/ddl"


# get opts
while getopts u:p:s:h OPT
do
	case $OPT in
		u)  USER=$OPTARG
		    ;;
		p)  PASSWORD=$OPTARG
		    ;;
    s)  SCRIPT_DIR=$OPTARG
    		;;
		h)  usage_exit
		    ;;
	esac
done
shift $((OPTIND - 1))

# main
CMD=`echo "create database $DATABASE_NAME CHARACTER SET utf8"`
OPTION=" -u $EXEC_USER -e \"$CMD\""
eval "mysql $OPTION"

CMD=`echo "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO $USER@localhost IDENTIFIED BY '$PASSWORD';FLUSH PRIVILEGES;"`
OPTION=" -u $EXEC_USER -e \"$CMD\" $DATABASE_NAME"
eval "mysql $OPTION"

SCRIPT_FILE=$SCRIPT_DIR"/cr_tbl_authorization.sql"
OPTION=" -u $EXEC_USER $DATABASE_NAME"
eval "cat $SCRIPT_FILE | mysql $OPTION"

SCRIPT_FILE=$SCRIPT_DIR"/cr_tbl_device.sql"
OPTION=" -u $EXEC_USER $DATABASE_NAME"
eval "cat $SCRIPT_FILE | mysql $OPTION"

exit 1
