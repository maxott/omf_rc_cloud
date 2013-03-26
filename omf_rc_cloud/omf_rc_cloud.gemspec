#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omf_rc_cloud/version"

Gem::Specification.new do |s|
  s.name        = "omf_rc_cloud"
  s.version     = OmfRcCloud::VERSION
  s.authors     = ["NICTA"]
  s.email       = ["omf-user@lists.nicta.com.au"]
  s.homepage    = "https://www.mytestbed.net"
  s.summary     = %q{OMF6 proxy for cloud installation.}
  s.description = %q{A OMF6 resource proxy to create resources which can be provided
    by a specific cloud installation.}

  s.rubyforge_project = "omf_rc_cloud"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- {bin,sbin}/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
#  s.add_development_dependency "minitest", "~> 2.11.3"
  s.add_runtime_dependency "omf_rc" #, "~> 0.9"
  s.add_runtime_dependency "fog" #, "~> 0.8.3"
  #OptionParser-0.5.1
  
  # SHould be in OmfCommon
  #amqp-0.9.8
  #daemons-1.1.9
end
