#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "omf_rc_cloud_node"
#  s.version     = OmfWeb::VERSION
  s.version     = '0.0.1'
  s.authors     = ["NICTA"]
  s.email       = ["omf-user@lists.nicta.com.au"]
  s.homepage    = "http://omf.mytestbed.net"
  s.summary     = %q{startup script for OMF6 proxy on cloud nodes.}
  s.description = %q{Scripts to start a node proxy for a cloud node. This is
    used for nodes created through the 'omf_rc_cloud' proxy.}

  s.required_ruby_version = '>= 1.9.3'
  s.license = 'MIT'

  s.rubyforge_project = "omf_rc_cloud_node"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- {bin,sbin}/*`.split("\n").map{ |f| File.basename(f) }
  s.executables   = `git ls-files -- {bin}/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
#  s.add_development_dependency "minitest", "~> 2.11.3"
  s.add_runtime_dependency "omf_rc" #, "~> 0.9"
  s.add_runtime_dependency "OptionParser" #, "~> 0.8.3"
  #daemons-1.1.9
end
