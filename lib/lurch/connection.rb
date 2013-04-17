require_relative 'event'

module Lurch
  class Connection < EM::Connection

    attr_accessor :server

    def post_init
      send_data "Hi\n"
    end

    def receive_data(json)
      data = JSON.parse(json)
      event = Event.new(data['service'], data['user'], data['message'])

      server.accept(event)
    end

    def unbind
      server.connections.delete(self)
    end

  end
end
