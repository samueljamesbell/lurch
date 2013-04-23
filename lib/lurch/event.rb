module Lurch
  class Event

    attr_accessor :service, :user, :message

    def initialize(service, user, message, opts = {})
      @service = service
      @user = user
      @message = message

      @urgent = opts[:urgent]
      @question = opts[:question]
      @silent = opts[:silent]
    end

    def command?
      @service == 'command'
    end

    def urgent?
      @urgent
    end

    def question?
      @question
    end

    def silent?
      @silent
    end

  end
end
