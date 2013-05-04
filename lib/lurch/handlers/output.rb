module Lurch
  module Handlers
    class Output < Lurch::Handler

      rule /.*/ do
        if event.command? && ! event.handled?
          server.send(%Q{Sorry, I don't understand what you mean by "#{event.message}"\n})
        else
          server.send(event.message + "\n") unless event.silent? || event.handled?
        end
      end

    end
  end
end
