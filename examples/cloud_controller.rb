# OMF_VERSIONS = 6.0
require 'omf_common'

OP_MODE = :development
#OP_MODE = :test_dev

  
  
cloud_opts = {
  #:provider => 'OpenStack',
  :type => :openstack,
  :openstack_auth_token => "f34dac0eec9845b88cb831d50ba2da4a",
  :openstack_management_url => "http://cloud.npc.nicta.com.au:8774/v2/6fee1fa4e35c4e44bd38f613021795e5",
  :openstack_tenant => '6fee1fa4e35c4e44bd38f613021795e5',
  :openstack_auth_url =>  'http://cloud.npc.nicta.com.au:5000/v2.0/tokens'
}

opts = {
  communication: {
    type: :amqp,
    #type: :local,
    server: 'srv.mytestbed.net'
  },
  eventloop: { type: :em},
}

def create_server(cloud)
  sopts = {
    name: 's2',
    flavor: 'm1.tiny',
    image: 'Ubuntu 12.04 cloudimg amd64',
    image: 'max - ubuntu - LTS'
  }
  cloud.create(:server, sopts) do |msg|
    if msg.success?
      server = msg.resource
      on_server_created(server, cloud)
    else
      logger.error "Resource creation failed - #{msg[:reason]}"
    end
  end
end


# This method is called whenever a new server has been created by the cloud.
#
# @param [Topic] server Topic representing the created server
# 
def on_server_created(server, cloud)
  # Monitor all status information from the server
  server.on_inform_status do |msg|
    msg.each_property do |name, value|
      logger.info "#{name} => #{value}"
    end
  end

  server.on_inform_failed do |msg|
    logger.error msg.read_content("reason")
  end

  # Some time later, we want to reduce the throttle to 0, to avoid blowing up the server
  # server.after(5) do
    # server.configure(throttle: 0)
  # end

  # 10 seconds later, we will 'release' this server, i.e. shut it down
  server.after(10) do
    logger.info "Time to release server #{server}"
    cloud.release server do |rmsg|
      info "===> server RELEASED: #{rmsg}"
    end
  end
end

def initialize_cloud(name, provider_opts = {})
  require 'omf_rc'
  require 'omf_rc/resource_factory'  
  require 'omf_rc_cloud/cloud'
  opts = {
    hrn: name,
    provider: provider_opts
  }
  cloud_inst = OmfRc::ResourceFactory.create(:cloud, opts)
end

# Environment setup
OmfCommon.init(OP_MODE, opts) do |el|

#OmfCommon.eventloop.run do |el|
  OmfCommon.comm.on_connected do |comm|
    
    initialize_cloud('cloud_1', cloud_opts)

    # Get handle on existing entity
    comm.subscribe('cloud_1') do |cloud|
    
      cloud.on_inform_failed do |msg|
        logger.error msg
      end
      # wait until cloud topic is ready to receive
      cloud.on_subscribed do
        create_server(cloud)
      end
    end
    
    el.after(20) { el.stop }
  end
end


info "DONE"

