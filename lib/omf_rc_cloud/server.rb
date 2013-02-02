#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
require 'omf_rc'

# Proxy for a single server (VM) provided by the cloud
#
module OmfRcCloud::Server
  include OmfRc::ResourceProxyDSL

  register_proxy :server, :create_by => :cloud
  
  property :flavor
  property :image
  

  #property :max_power, :default => 676 # Set the server maximum power to 676 bhp

  # before_ready hook will be called during the initialisation of the resource instance
  #
  hook :before_ready do |server|
    #puts ">>>> #{server.inspect}"
  end

  hook :after_initial_configured do |server|
    #puts "AFTER>>> #{server.property}"
    begin 
      shandle = server.property.server_handle = OmfRcCloud::Provider.instance.server_create(server)
      info "Server #{server.uid}::#{server.property.server_handle} configured using options defined in create messages."
      
      last_status_h = {} 
      OmfCommon.eventloop.every(5) do
        status_h = OmfRcCloud::Provider.instance.server_get_status(shandle)
        unless status_h == last_status_h
          server.inform(:status, status_h)
        end
        last_status_h = status_h
      end
    rescue OmfRcCloud::Provider::ProviderUnauthorizedException => pex
      raise "Cloud Provider not authorized"
    end
  end

  # before_release hook will be called before the resource is fully released.
  #
  hook :before_release do |server|
  end

  [:image, :flavor].each do |p_name|
    configure p_name do |server, value|
      server.property[p_name] = value
    end
  end


  request :image do |server|
  end


end
