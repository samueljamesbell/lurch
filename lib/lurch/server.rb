require_relative 'connection'

module Lurch
  class Server

    attr_accessor :connections

    def initialize
      @connections = []
      Handler.server = self
    end

    def start
      EventMachine.start_server '0.0.0.0', 2013, Connection do |conn|
        conn.server = self
        @connections << conn
      end
    end

    def accept(event)
      Handler.match(event) unless event.direct?
      output(event)
    end

    private

    def output(event)
      if event.command?
        send(not_handled(event.message)) unless event.handled?
      else
        send(event.message) unless event.silent?
      end
    end

    def not_handled(message)
      %Q{Sorry, I don't understand "#{message}"}
    end

    def send(data)
      @connections.each { |conn| conn.send_data("#{data}\n") }
    end

  end
end

