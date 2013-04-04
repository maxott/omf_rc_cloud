#!/bin/bash

# Startup wrapper for the OMF6 Cloud Node RC

die() { echo "ERROR: $@" 1>&2 ; exit 1; }

RUBY_VER="ruby-1.9.3-p286"

CONFIG_FILE=/etc/omf_rc/cloud_node.yaml
CLOUD_NODE_RC_DIR="/usr/local/rvm/gems/${RUBY_VER}@omf/omf_rc_cloud_node"


if [ `id -u` != "0" ]; then
	die "This script is intended to be run as 'root'"
fi

if [ ! -e /usr/local/rvm/bin/rvm ]; then
  die "Can't find 'rvm' installed in '/usr/local/rvm'"
fi

if [ ! -e /usr/local/rvm/gems/${RUBY_VER}@omf ]; then
  die "Can't find ruby binary '${RUBY_VER}' and 'omf' gem set"
fi

if [ ! -e /usr/local/rvm/gems/${RUBY_VER}@omf ]; then
  die "Can't find ruby binary '${RUBY_VER}' and 'omf' gem set"
fi

if [ ! -e $CONFIG_FILE ]; then
  die "Can't find config file '${CONFIG_FILE}'."
fi

echo "Running OMF6 Cloud Node RC"
cd $CLOUD_NODE_RC_DIR
/usr/local/rvm/bin/rvm ${RUBY_VER}@oml exec bundle install
exec /usr/local/rvm/bin/rvm ${RUBY_VER}@oml exec bundle exec ruby foo -c ${CONFIG_FILE} $@