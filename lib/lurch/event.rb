module Lurch
  class Event

    attr_accessor :service, :user, :message

    def initialize(service, user, message, status = nil)
      @service = service
      @user = user
      @message = message

      @status = status
    end

    def command?
      @service == 'command'
    end

    def question?
      @status == :question
    end

    def silent?
      @status == :silent
    end

  end
end
