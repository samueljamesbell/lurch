module Lurch
  class Event

    attr_accessor :service, :message

    def initialize(service, message)
      @service = service
      @message = message

      validate

      @handled = false
    end

    def handled!
      @handled = true
    end

    def handled?
      @handled
    end

    # todo: don't know how these fit in either - see handler.rb
    def command?
      @service == 'command'
    end

    def question?
      @status == :question
    end

    def direct?
      @status == :direct
    end

    def silent?
      @status == :silent
    end

    private

    def validate
      validate_presence_of_service
      validate_presence_of_message
    end

    def validate_presence_of_service
      unless @service && @service != ''
        raise ArgumentError, "Event service must not be blank"
      end
    end

    def validate_presence_of_message
      unless @message && @message != ''
        raise ArgumentError, "Event message must not be blank"
      end
    end

  end
end
