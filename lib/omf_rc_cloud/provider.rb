#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
module OmfRcCloud
  # Abstract class providing the interface
  # to the cloud technology specific classes
  class Provider
    @@providers = {
      openstack: {
        require: 'omf_rc_cloud/provider/openstack/openstack_provider',
        constructor: 'OmfRcCloud::Provider::OpenStack'
      },
      aws: {
        require: 'omf_rc_cloud/provider/aws/openstack_provider',
        constructor: 'OmfRcCloud::Provider::AWS'
      },
    }
    @@instance = nil
    
    class ProviderException < Exception; end
    class ProviderUnauthorizedException < ProviderException; end
    
    #
    # opts:
    #   :type - pre installed stack technology provider
    #   :provider - custom provider (opts)
    #     :require - gem to load first (opts)
    #     :constructor - Class implementing provider
    #
    def self.init(opts)
      if @@instance
        raise "Cloud technology provider already initialised"
      end
      unless provider = opts[:provider]
        provider = @@providers[opts[:type].to_sym]
      end
      unless provider
        raise "Missing Cloud provider declaration. Either define 'type' or 'provider'"
      end

      require provider[:require] if provider[:require]
      if class_name = provider[:constructor]
        provider_class = class_name.split('::').inject(Object) {|c,n| c.const_get(n) }
        inst = provider_class.new()
      else
        raise "Missing creation info - :constructor"
      end
      @@instance = inst
      inst.init(opts)
    end
    
    def self.instance
      @@instance
    end
    
    def server_create(server_proxy)
      raise "Not implmented"
    end
    
    def server_get_status(server_handle)
      raise "Not implmented 'server_get_status'"
    end
  end
end
