#!/usr/bin/env ruby

require 'omf_common'
require 'omf_rc'
require 'omf_rc/resource_factory'  

OP_MODE = :development
#OP_MODE = :test_dev

config_file = File.join(File.dirname($0), 'node_proxy.yaml')
op = OptionParser.new
op.on '-c', '--config-file FILE', "File to read configuration parameters from [#{config_file}]" do |f|
  config_file = f
end
op.parse!


#
# This script starts a node proxy on a cloud instance. It assumes that
# various configuration options are being copied onto the VM by the
# cloud provider.
#

opts = OmfCommon.load_yaml config_file, {
  symbolize_keys: true, 
  remove_root: :proxy, 
  wait_for_readable: 2
}
puts ">>>> #{opts.inspect}"

resources_opts = opts.delete(:resources)
proxies = []
OmfCommon.init(OP_MODE, opts) do |el|
  
  if resources_opts.empty?
    error "Can't find any proxies to create"
    exit(-1)
  end
  
  OmfCommon.comm.on_connected do |comm|
    default_proxies_loaded = false
    resources_opts.each do |resource_opts|
      unless type = resource_opts.delete(:type)
        error "Can't find type of proxy to create - #{resource_opts.inspect}"
        exit(-1)
      end
      if req = resource_opts.delete(:require)
        require req
      elsif not default_proxies_loaded
        OmfRc::ResourceFactory.load_default_resource_proxies
        default_proxies_loaded = true
      end
      proxies << OmfRc::ResourceFactory.create(type, resource_opts)
    end
  end
end

