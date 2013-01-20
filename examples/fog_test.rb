require 'fog'
require 'pp'

connection = Fog::Compute.new({
  :provider => 'OpenStack',
  :openstack_auth_token => "bfc3170856f74ceeacf717d8a3857dee",
  :openstack_management_url => "http://cloud.npc.nicta.com.au:8774/v2/6fee1fa4e35c4e44bd38f613021795e5",
  :openstack_tenant => '6fee1fa4e35c4e44bd38f613021795e5',
  :openstack_auth_url =>  'http://cloud.npc.nicta.com.au:5000/v2.0/tokens'
})


def create_vm(connection, name)
  connection.servers.create({
    name: 'test1',
    flavor_ref: 3, #"m1.medium",
    image_ref: "6593c4c3-a5c8-4059-861e-af6b221404a7",
    security_group_ref: 4
  })
end

#pp create_vm connection, 'test1'
connection.servers.each do |server|
  pp server
  server.addresses.each do |addr|
    pp addr
  end
  pp server.image.class
end
#pp connection.flavors
#pp connection.addresses
#pp connection.security_groups

  
