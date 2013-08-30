#!/bin/bash

# Startup wrapper for the OMF6 Cloud Node RC

die() { echo "ERROR: $@" 1>&2 ; exit 1; }

RUBY_VER="ruby-1.9.3-p286"

CONFIG_FILE=/etc/omf_rc/cloud_node.yaml
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE="${BASH_SOURCE[0]}"
CLOUD_NODE_RC_DIR="${DIR}/.."

if [ `id -u` != "0" ]; then
	die "This script is intended to be run as 'root'"
fi

if [ ! -e /usr/local/rvm/bin/rvm ]; then
  die "Can't find 'rvm' installed in '/usr/local/rvm'"
fi

if [ ! -e /usr/local/rvm/bin/${RUBY_VER} ]; then
  echo "Need to first install missing ${RUBY_VER}"
  /usr/local/rvm/bin/rvm install --autolibs=4 ${RUBY_VER}
fi

if [ ! -e $CONFIG_FILE ]; then
  die "Can't find config file '${CONFIG_FILE}'."
fi

echo "Running OMF6 Cloud Node RC"
cd $CLOUD_NODE_RC_DIR
rm Gemfile.lock
/usr/local/rvm/bin/rvm ${RUBY_VER} exec ruby lib/omf_rc_cloud_node/util/build_gem_file.rb -c $CONFIG_FILE
if [ ! -e vendor ]; then
  /usr/local/rvm/bin/rvm ${RUBY_VER} exec bundle package --all
else
  /usr/local/rvm/bin/rvm ${RUBY_VER} exec bundle update
fi
exec /usr/local/rvm/bin/rvm ${RUBY_VER} exec bundle exec ruby lib/omf_rc_cloud_node.rb -c ${CONFIG_FILE} -m production $@

