module Lurch
  module Handlers
    class Weather < Handler

      rule /weather\s(in|at)\s(\w*)/ do
        message 'The weather is nice today'
      end

    end
  end
end
