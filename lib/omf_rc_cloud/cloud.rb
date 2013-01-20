
require 'omf_rc'
require 'omf_rc_cloud'
require 'omf_rc_cloud/provider'

# This is the proxy for a single cloud installation.
# it will not dynamically created, but is one of the
# few 'bootstrap' anchors in OMF.
#
module OmfRcCloud::Cloud
  include OmfRc::ResourceProxyDSL

  register_proxy :cloud

  hook :before_ready do |cloud|
    #puts "CLOUD before_ready: #{cloud.property}"
    OmfRcCloud::Provider.init(cloud.property.provider)
    info "Cloud #{cloud.uid} configured."
  end


end
