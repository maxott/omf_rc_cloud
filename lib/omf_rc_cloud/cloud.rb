#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
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
