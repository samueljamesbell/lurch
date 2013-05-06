require_relative 'event'

module Lurch
  class Connection < EM::Connection

    attr_accessor :server

    def receive_data(json)
      data = JSON.parse(json)
      event = Event.new(data['service'], data['user'], data['message'])

      server.accept(event)
    rescue JSON::ParserError => e
      send_data "ERROR: Invalid JSON\n#{e.message}\n"
    rescue ArgumentError => e
      send_data "ERROR: Invalid Event\n#{e.message}\n"
    end

    def unbind
      server.connections.delete(self)
    end

  end
end
