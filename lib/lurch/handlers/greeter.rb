module Lurch
  module Handlers
    class Greeter < Handler

      rule /hello|hi|hey/ do
        direct "Hey #{event.user}, ask me anything"
      end

    end
  end
end
