#!/usr/bin/env ruby
#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------

require 'omf_common'
require 'omf_rc'
require 'omf_rc/resource_factory'  
require 'optparse'


def just_doit
  if $0.start_with? '-' # started with -e command line
    $0 = File.basename(__FILE__, '.rb')
  end
    
  op_mode = :development
  #op_mode = :test_dev
  
  config_file = File.join(File.dirname($0), 'cloud_node.yaml')
  op = OptionParser.new
  op.on '-c', '--config-file FILE', "File to read configuration parameters from [#{config_file}]" do |f|
    config_file = f
  end
  op.on '-m', '--op-mode MODE', "OpMode to use when calling OmfCommon.init() [#{op_mode}]" do |m|
    op_mode = m
  end
  op.on_tail('-h', "--help", "Show this message") { $stderr.puts op; exit }
  op.parse!
  
  
  #
  # This script starts a node proxy on a cloud instance. It assumes that
  # various configuration options are being copied onto the VM by the
  # cloud provider.
  #
  opts = OmfCommon.load_yaml config_file, {
    symbolize_keys: true, 
    remove_root: :proxy, 
    wait_for_readable: 2,
    erb_process: true
  }
  puts opts
  
  resources_opts = opts.delete(:resources)
  proxies = []
  OmfCommon.init(op_mode, opts) do |el|
    
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
        create_opts = resource_opts.delete(:create_opts) || {}
        membership = resource_opts.delete(:membership)
        r = OmfRc::ResourceFactory.create(type, resource_opts, create_opts)
        r.configure_membership(membership) if membership
        proxies << r
      end
    end
  end
end
