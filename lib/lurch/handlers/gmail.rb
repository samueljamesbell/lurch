module Lurch
  module Handlers
    class Gmail < Handler

      rule /test/ do
        puts 'TEST WORKED'
      end

    end
  end
end
