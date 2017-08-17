#!/bin/bash

# td-agent_installer

# usage
usage_exit() {
  echo "Usage: $0 [-d unzip_installer_dir]" 1>&2
      exit 1
}

# default value
INST_DIR="/opt/apppot-iot"
CONF_DIST_DIR="/opt/td-agent/conf"
SOURCE_FILE="td-agent-2.3.3-0.el6.x86_64.tar.gz"
RPM_FILE="td-agent-2.3.3-0.el7.x86_64.rpm"
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
GEM_DIR=$SOURCE_DIR/gem_fluentd
CONF_DIR=$INST_DIR/fluentd/conf

# main
if [ -e $INST_DIR ]; then
    echo "directory found."
else
    echo "directory not found."
    usage_exit
fi

echo "td-agentをインストールします。"

yum localinstall -y $SOURCE_DIR/$RPM_FILE

echo "fluent-pluginをインストールします。"

td-agent-gem install -l $GEM_DIR/multi_json-1.12.1.gem $GEM_DIR/elasticsearch-api-1.0.18.gem $GEM_DIR/multipart-post-2.0.0.gem $GEM_DIR/faraday-0.9.2.gem $GEM_DIR/elasticsearch-transport-1.0.18.gem $GEM_DIR/elasticsearch-1.0.18.gem $GEM_DIR/excon-0.52.0.gem $GEM_DIR/fluent-plugin-elasticsearch-1.7.0.gem $GEM_DIR/ltsv-0.1.0.gem $GEM_DIR/ruby-kafka-0.3.15.gem $GEM_DIR/fluent-plugin-kafka-0.4.0.gem

echo "fluentd.confをコピーします。"
mkdir -p $CONF_DIST_DIR
cp $CONF_DIR/apppot-iot.conf $CONF_DIST_DIR

exit 1
