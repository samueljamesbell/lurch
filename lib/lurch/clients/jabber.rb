require 'json'
require 'socket'
require 'blather/client'

module Lurch
  module Clients
    class Jabber < Blather::Client

      def initialize
        super

        @socket = TCPSocket.new 'localhost', 2013

        register_handler :message, :chat? do |message|
          on_message(message)
        end

        register_handler :subscription, :request? do |request|
          write request.approve!
        end
      end

      def on_message(message)
        event = {:service => :command, :user => :sam, :message => message.body}
        @socket.sendmsg event.to_json
      end

    end
  end
end
