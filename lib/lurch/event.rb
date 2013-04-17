module Lurch
  class Event

    attr_accessor :service, :user, :message

    def initialize(service, user, message, bypass = false)
      @service = service
      @user = user
      @message = message
      @bypass = bypass
    end

    def priority
      if command?  2
      elsif bypass?  1
      else 0
      end
    end

    def command?
      @service == 'command'
    end

    def bypass?
      @bypass
    end

  end
end
