module Lurch
  class Event

    attr_accessor :service, :user, :message

    def intialize(service, user, message, opts = {})
      @service = service
      @user = user
      @message = message

      @bypass = opts[:bypass]
      @silent = opts[:silent]
    end

    def command?
      @service == 'command'
    end

    def bypass?
      @bypass
    end

    def silent?
      @silent
    end

  end
end
