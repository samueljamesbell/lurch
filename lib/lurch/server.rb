module Lurch
  class Server

    attr_accessor :queue, :connections

    def initialize
      @queue = []
      @connections = []
    end

    def start
      EventMachine.start_server '0.0.0.0', 2013, Connection do |conn|
        conn.server = self
        @connections << conn
      end
    end

    def accept(event)
      @queue << event
      puts @queue.inspect
    end

    def send(data)
      @connections.each { |conn| conn.send_data(data) }
    end

  end
end

