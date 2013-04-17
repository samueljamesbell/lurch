module Lurch
  module Handlers
    class Gmail < Handler

      rule /test/ do
        puts 'TEST WORKED'
        test_method
      end

      def test_method
        puts 'METHOD WORKED'
      end

    end
  end
end
