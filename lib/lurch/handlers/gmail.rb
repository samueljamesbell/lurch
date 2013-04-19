module Lurch
  module Handlers
    class Gmail < Handler

      rule /test/ do |matches|
        puts 'TEST WORKED'
        test_method
        puts matches.inspect
      end

      def test_method
        fail

        puts 'METHOD WORKED'
      end

      rule /test(.)?/ do
        puts 'another one'
      end

      rule /shouldntmatch/ do
        puts 'should not be called'
      end

    end
  end
end
