module Lurch
  class Event

    attr_accessor :service, :user, :message

    def initialize(service, user, message, status = nil)
      @user = User[:email => user] ||
        User.create(:email => user, :name => nil)

      @service = service
      @message = message

      validate

      @handled = false

      @status = status
    end

    def handled!
      @handled = true
    end

    def handled?
      @handled
    end

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
      validate_presence_of_user
      validate_presence_of_message
    end

    def validate_presence_of_service
      unless @service && @service != ''
        raise ArgumentError, "Event service must not be blank"
      end
    end

    def validate_presence_of_user
      unless @user && @user != ''
        raise ArgumentError, "Event user must not be blank"
      end
    end

    def validate_presence_of_message
      unless @message && @message != ''
        raise ArgumentError, "Event message must not be blank"
      end
    end

  end
end
