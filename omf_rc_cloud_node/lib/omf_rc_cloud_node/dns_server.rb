require 'rubydns'

module OmfRcCloud
  module DnsServer
    include ::OmfRc::ResourceProxyDSL

    register_proxy :dns_server

    property :ports, :default => [
      {protocol: :udp, port: 53, interface: "0.0.0.0"},
      {protocol: :tcp, port: 53, interface: "0.0.0.0"}
    ], :readonly => true

    property :domain, :default => 'mydomain.org', :readonly => true  # all hosts are within this domain
    property :mapping, :default => {
      n1: '10.0.0.1',
      n2: '10.0.0.2',
      n5: '10.0.0.5'
    }

    property :upstream_server, :default => [
      [:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]
    ], readony => true

    hook :after_initial_configured do |res|
      #puts "AFTER CONFIGURED"
      res.recalculate_mappings
      res.start_dns_server
    end

    hook :before_release do |res|
      info "RELEASING #{res}"
      if @server
        @server.fire(:stop)
        @server = nil
      end
    end

    configure :domain do |res, val|
      res.property.domain = val
      res.recalculate_mappings
    end

    configure :mapping do |res, val|
      res.property.mapping = val
      res.recalculate_mappings
    end

    work :recalculate_mappings do
      OmfCommon.eventloop.after(0) do # defer to make sure domain is set to the right value, too
        @name2ip = {}
        @ip2name = {}
        domain = ".#{res.property.domain}"
        res.property.mapping.each do |name, ip|
          unless name.include? '.'
            name = name + domain
          end
          @name2ip[name] = ip
          @ip2name[ip.split('.').reverse.join('.') + '.in-addr.arpa'] = name
        end
      end
    end

    work :start_dns_server do |res|
      @server = RubyDNS::Server.new()
      @server.logger = get_logger('server')
      @server.logger.info "Starting RubyDNS server (v#{RubyDNS::VERSION})..."

      OmfCommon.eventloop.after(0) do
        # TODO: Check if eventloop is EventMachine
        #
        @server.fire(:setup)

        # Setup server sockets
        res.property.ports.each do |spec|
          @server.logger.info "Listening on #{spec}"
          interface = spec[:interface] || '0.0.0.0'
          port = (spec[:port] || 53).to_i
          case protocol = spec[:protocol]
          when :udp
            #puts "IF: '#{interface}' port: '#{port}'::#{port.class}"
            EventMachine.open_datagram_socket(interface, port, RubyDNS::UDPHandler, @server)
          when :tcp
            EventMachine.start_server(interface, port, RubyDNS::TCPHandler, @server)
          else
            error "Unknown protocol '#{protocol}"
          end
        end

        Name = Resolv::DNS::Name
        IN = Resolv::DNS::Resource::IN

        @server.match(/#{Regexp.escape(res.property.domain)}/, IN::A) do |transaction|
          #puts @name2ip.inspect
          if addr = @name2ip[transaction.question.to_s]
            transaction.respond!(addr)
          end
        end

        @server.match(/#{Regexp.escape('.in-addr.arpa')}/, IN::PTR) do |transaction|
          if name = @ip2name[transaction.question.to_s]
            transaction.respond!(Name.create(name))
          end
        end

        # Default DNS handler
        upstream = RubyDNS::Resolver.new([[:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]])
        @server.otherwise do |transaction|
          transaction.passthrough!(upstream)
        end

        @server.fire(:start)
      end
    end

  end
end
