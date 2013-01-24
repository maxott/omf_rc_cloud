#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
require 'fog'
require 'pp'

connection = Fog::Compute.new({
  provider: 'AWS',
  aws_access_key_id: 'ca233d6ab82b41a985ecfe5f47374f6e',
  aws_secret_access_key: '40b2ac90394141c49c82fdf37af3a74d',
  #region: 'RegionOne', # ???
  endpoint: 'http://cloud.npc.nicta.com.au:8773/services/Cloud'
})


def create_vm(connection, name)
  connection.servers.create({
    name: 'test1',
    flavor_id: "m1.medium",
    image_id: "ami-00000023",
    security_group_ref: 4
  })
end

#pp create_vm connection, 'test1'
pp connection.servers
##pp connection.addresses
#pp connection.images
#pp connection.flavors
#pp connection.security_groups

  
