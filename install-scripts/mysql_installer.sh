#!/bin/bash

# td-agent_installer

# usage
usage_exit() {
    echo "Usage: $0 [-d unzip_installer_dir]" 1>&2
        exit 1
}

# default value
INST_DIR="./installer"
SOURCE_FILE="mysql-5.7.16-1.el6.x86_64.tar.gz"
# get opts
while getopts d:h OPT
do
	case $OPT in
		d)  INST_DIR=$OPTARG
		    ;;
		h)  usage_exit
		    ;;
	esac
done
shift $((OPTIND - 1))

SOURCE_DIR=$INST_DIR/middleware

# main
if [ -e $SOURCE_DIR ]; then
    echo "directory found."
    DIST_DIR=$SOURCE_DIR/temp
    mkdir -p $DIST_DIR
else
    echo "directory not found."
    usage_exit
fi


#SOURCE_DIR=`echo $(cd $(dirname -- $0) && pwd)`
tar zxvf $SOURCE_DIR/$SOURCE_FILE -C $DIST_DIR

echo "default mariadb remove"
yum remove -y mariadb-libs

echo "mysql install"
yum localinstall -y $DIST_DIR/mysql-community-client-5.7.16-1.el6.x86_64.rpm $DIST_DIR/mysql-community-devel-5.7.16-1.el6.x86_64.rpm $DIST_DIR/mysql-community-common-5.7.16-1.el6.x86_64.rpm $DIST_DIR/mysql-community-server-5.7.16-1.el6.x86_64.rpm $DIST_DIR/mysql-community-libs-5.7.16-1.el6.x86_64.rpm $DIST_DIR/mysql-community-libs-compat-5.7.16-1.el6.x86_64.rpm --skip-broken

exit 1
