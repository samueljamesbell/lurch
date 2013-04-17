module Lurch
  class Rule < Sequel::Model

    set_primary_key [:handler, :pattern]

    def frecency
      0 # calculate from last_updated and popularity
    end

  end
end
