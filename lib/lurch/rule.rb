module Lurch
  class Rule < Sequel::Model

    attr_accessor :block

    set_primary_key [:handler, :pattern]

    def priority
      frecency # unless coming from Lurch::Output::Handler?
    end

    def frecency
      0 # calculate from last_updated and popularity
    end

  end
end
