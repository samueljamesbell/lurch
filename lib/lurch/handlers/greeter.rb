module Lurch
  module Handlers
    class Greeter < Handler

      rule /hello|hi|hey/ do
        # todo: create an interface to wrap up even creation and dispatch
        event = Lurch::Event.new('greeter', 'Hallo!');
        Lurch::Dispatch.send(event);
      end

    end
  end
end
