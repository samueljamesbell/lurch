module Lurch
  module Handlers
    class Gmail < Handler

      rule /test/ do |matches|
        puts 'TEST WORKED'
        test_method
        puts matches.inspect
      end

      def test_method
        puts 'METHOD WORKED'
      end

    end
  end
end
