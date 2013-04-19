module Lurch
  module Handlers
    class Output < Lurch::Handler

      rule /.*/, -1 do
        if event.command?
          server.send(%Q{Sorry, I don't understand what you mean by "#{event.message}"\n})
        else
          server.send(event.message + "\n")
        end
      end

    end
  end
end
