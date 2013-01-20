# OMF Cloud Proxy

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


