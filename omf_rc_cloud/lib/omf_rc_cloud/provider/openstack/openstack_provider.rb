#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
require 'fog'
require 'omf_rc_cloud/provider/openstack/fog_monkey_patches'
require 'yaml'

module OmfRcCloud
  class Provider
    class OpenStack < Provider
    end
    
    def init(opts)
      unless opts[:openstack_auth_token] && opts[:openstack_management_url] && 
        opts[:openstack_tenant] && opts[:openstack_auth_url]
          raise "Missing information to connect to OpenStack API"
      end
      @connection = Fog::Compute.new({
        :provider => 'OpenStack',
        :openstack_auth_token => opts[:openstack_auth_token],
        :openstack_management_url => opts[:openstack_management_url],
        :openstack_tenant => opts[:openstack_tenant],
        :openstack_auth_url =>  opts[:openstack_auth_url]
      })
    end
    
    def server_create(server_proxy)
      begin 
        uid = server_proxy.uid
        opts = server_proxy.property
        copts = {
          name: uid,
          flavor_ref: flavor_find(opts[:flavor]).id,
          image_ref: image_find(opts[:image]).id,
        } 
        server = @connection.servers.new copts
        
        # meta = {
          # resource_id: uid,
          # #parent_id: server.parent.uid,
          # communication: OmfCommon.comm.options
        # }
        # server.metadata = {omf6: meta.to_s}
        
        
        sp = {
          'type' => 'node',
          'uid' => uid
        }
        if hrn = server_proxy.hrn
          sp['hrn']
        end
        server.personality = [{
          'path' => '/etc/omf_rc/node_proxy.yaml',
          'contents' => {
            'proxy' => {
              'communication' => OmfCommon.comm.options,
              'resources' => [sp]
            }
          }.to_yaml
        }]
        server.save
        @servers << server
        #debug server.inspect
        server
      rescue Excon::Errors::Unauthorized => ex
        error "Auth token to create servers has expired"
        raise ProviderUnauthorizedException.new
      end
    end
    
    def server_get_status(server)
      server.reload
      debug server.inspect
      {
        state: server.state,
        interfaces: server.addresses
      }
    end
    
    def flavor_find(flavor_name)
      flavor = flavors.find do |f|
        #puts f.inspect
        f.name == flavor_name
      end
      flavor != nil ? flavor : raise("Flavor '#{flavor_name}' not defined on this cloud") 
    end

    def flavors
      @flavors = @connection.flavors
    end
    
    def image_find(image_name)
      image = images.find do |f|
        #puts f.inspect
        f.name == image_name
      end
      image != nil ? image : raise("image '#{image_name}' not defined on this cloud") 
    end

    def images
      @images = @connection.images
    end
    
    def initialize()
      @servers = []
    end
    
  end
end
