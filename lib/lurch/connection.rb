module Lurch
  class Connection < EM::Connection
    def receive_data(data)
      LURCH.accept(data)
    end
  end
end
