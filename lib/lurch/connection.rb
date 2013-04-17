module Lurch
  class Connection < EM::Connection

    attr_accessor :server

    def receive_data(data)
      server.accept(data)
    end

    def unbind
      server.connections.delete(self)
    end

  end
end
