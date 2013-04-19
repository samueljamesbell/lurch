module Lurch
  class Rule < Sequel::Model

    attr_accessor :block
    attr_writer :priority

    set_primary_key [:handler, :pattern]
    unrestrict_primary_key

    def priority
      @priority || frecency
    end

    def frecency
      current = Time.now

      one_hour_ago = current - 3600
      one_day_ago = current - 86400
      one_week_ago = current - 604800

      if self.last_accessed > one_hour_ago
        multiplier = 4
      elsif self.last_accessed > one_day_ago
        multiplier = 2
      elsif self.last_accessed > one_week_ago
        multiplier = 0.5
      else
        multiplier = 0.25
      end

      self.rank * multiplier
    end

    def update_frecency
      self.rank += 1
      self.last_accessed = Time.now

      save
    end

  end
end
