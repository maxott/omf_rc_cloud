#!/bin/bash

# Startup wrapper for the OMF6 RC
# detects system-wide RVM installations & Ruby from distro packages
# and runs OMF6 RC

# system-wide RVM must be installed using
# '\curl -L https://get.rvm.io | sudo bash -s stable'

die() { echo "ERROR: $@" 1>&2 ; exit 1; }

RUBY_VER="ruby-1.9.3-p286"
RUBY_BIN_SUFFIX=""

if [ `id -u` != "0" ]; then
	die "This script is intended to be run as 'root'"
fi

if [ -e /etc/profile.d/rvm.sh ]; then
    # use RVM if installed
    echo "System-wide RVM installation detected"
    source /etc/profile.d/rvm.sh
    if [[ $? != 0 ]] ; then
        die "Failed to initialize RVM environment"
    fi
    rvm use $RUBY_VER@omf > /dev/null
    if [[ $? != 0 ]] ; then
        die "$RUBY_VER with gemset 'omf' is not installed in your RVM"
    fi
    ruby -v | grep 1.9.3  > /dev/null
    if [[ $? != 0 ]] ; then
        die "Could not run Ruby 1.9.3"
    fi
    gem list | grep omf_rc  > /dev/null
    if [[ $? != 0 ]] ; then
        die "The omf_rc gem is not installed in the 'omf' gemset"
    fi
else
    # check for distro ruby when no RVM was found
    echo "No system-wide RVM installation detected"
    ruby -v | grep 1.9.3  > /dev/null
    if [[ $? != 0 ]] ; then
        ruby1.9.3 -v | grep 1.9.3  > /dev/null
        if [[ $? != 0 ]] ; then
            die "Could not run system Ruby 1.9.3. No useable Ruby installation found."
        fi
        RUBY_BIN_SUFFIX="1.9.3"
    fi
    echo "Ruby 1.9.3 found"
    gem$RUBY_BIN_SUFFIX list | grep omf_rc  > /dev/null
    if [[ $? != 0 ]] ; then
        die "The omf_rc gem is not installed"
    fi
fi

RC=`which omf_rc`
if [[ $? != 0 ]] ; then
    die "could not find omf_rc executable"
fi

echo "Running OMF6 RC"
exec /usr/bin/env ruby$RUBY_BIN_SUFFIX $RC -c /etc/omf_rc/config.yml $@