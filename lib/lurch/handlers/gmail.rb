module Lurch
  module Handlers
    class Gmail < Handler

      rule /test/, 1000000 do
        puts 'TEST WORKED'
        puts matches.inspect
        test_method
      end

      def test_method
        fail

        puts 'METHOD WORKED'
      end

      rule /test(.)?/ do
        puts 'another one'
        succeed
      end

      rule /shouldntmatch/ do
        puts 'should not be called'
        succeed
      end

    end
  end
end
