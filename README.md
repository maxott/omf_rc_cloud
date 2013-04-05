
# OMF Cloud Proxy

## Install

### On Cloud Node using Ubuntu

Ultimately it should be in a package repository, but for the moment you'll
need to fetch the package from github

    % curl https://github.com/maxott/omf_rc_cloud/blob/master/omf_rc_cloud_node/build/omf-rc-cloud-node-0.9_1_all.deb?raw=true
    % sudo apt-get install libgdbm-dev pkg-config libffi-dev git-core
    % sudo dpkg -i omf-rc-cloud-node-0.9_1_all.deb\?raw\=true
    
You'll then need to create a configuration file. In most cases setting either the AMQP or XMPP server informaiton will suffice

    % sudo cp /etc/cloud_node.yaml-example /etc/cloud_node.yaml
    % sudo vi /etc/cloud_node.yaml

Finally, you'll nee to start the daemon. It may take a while for it to come up initially as it may install
a specific ruby version if that isn't already available. It will also check and fetch any updates to the gems it is using.

    % sudo start omf_rc_cloud_node
    
-----

This gem provides an OMF proxy which can be configured to obtain and manage 
resources from a specifc cloud installation.

The supported cloud technologies are:

* **OpenStack**. Configuration instructins can be found [here](#openstack).

__Instructions on how to start the proxy__

## OpenStack <a id="widgets"/>

__Instructions on how to set the various paramaters and which file they would be in__

    cloud_provider:
      :type => :openstack,
      :openstack_auth_token => "f34dac0eec9845b88cb831d50ba2da4a",
      :openstack_management_url => "http://yourcloud.com:8774/v2/6fee1fa4e35c4e44bd38f613021795e5",
      :openstack_tenant => '6fee1fa4e35c4e44bd38f613021795e5',
      :openstack_auth_url =>  'http://yourcloud.com:5000/v2.0/tokens'


