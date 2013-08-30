
# OMF Cloud Proxy

## Install

### On Cloud Node using Ubuntu

Ultimately it should be in a package repository, but for the moment you'll
need to fetch the package from github

    % curl https://github.com/maxott/omf_rc_cloud/blob/master/omf_rc_cloud_node/build/omf-rc-cloud-node_latest_all.deb?raw=true
    % sudo apt-get install libgdbm-dev pkg-config libffi-dev git-core
    % sudo dpkg -i omf-rc-cloud-node-0.9_1_all.deb\?raw\=true
    
You'll then need to create a configuration file. In most cases setting either the AMQP or XMPP server informaiton will suffice

    % sudo cp /etc/cloud_node.yaml-example /etc/cloud_node.yaml
    % sudo vi /etc/cloud_node.yaml

Finally, you'll nee to start the daemon. It may take a while for it to come up initially as it may install
a specific ruby version if that isn't already available. It will also check and fetch any updates to the gems it is using.

    % sudo start omf_rc_cloud_node
    

## Build DEB File

This will most likely only work on Debian based distributions. Before building a package, make 
sure that the following packages are installed:

    sudo apt-get install devscripts
    sudo apt-get install debhelper
    
To build a 'deb' file:

    % rake package
    
The built packages can be found in the 'build' directory.
    