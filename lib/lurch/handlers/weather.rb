require 'net/http'
require 'json'

module Lurch
  module Handlers
    class Weather < Handler

      rule /weather (?:doing |like )?(?:in|at) (\w*)/ do
        location_name = matches[1]

        uri = URI("http://api.openweathermap.org/data/2.5/weather?q=#{location_name}&units=metric")
        response = JSON.parse(Net::HTTP.get(uri))

        description = response['weather'][0]['description'].capitalize
        temperature = response['main']['temp']

        "#{description} and #{temperature} degrees"
      end

    end
  end
end
