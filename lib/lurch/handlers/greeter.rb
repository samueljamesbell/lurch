module Lurch
  module Handlers
    class Greeter < Handler

      rule /hello|hi|hey/ do
        unless event.user.name
          event.user.name = question "Hi, what's your name?"
          event.user.save
        end

        direct "Ask me anything, #{event.user.name.capitalize}"
      end

    end
  end
end
