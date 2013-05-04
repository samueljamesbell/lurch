module Lurch
  module Handlers
    class Weather < Handler

      rule /weather (in|at) (\w*)/ do
        message 'The weather is nice today'
      end

    end
  end
end
