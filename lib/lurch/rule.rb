module Lurch
  class Rule < Sequel::Model
    include Comparable

    attr_accessor :block

    set_primary_key [:handler, :pattern]
    unrestrict_primary_key

    def <=>(other)
      if handler == 'Output'
        -1
      elsif other.handler == 'Output'
        1
      elsif Handler.latest == handler
        1
      elsif Handler.latest == other.handler
        -1
      elsif Handler.instances[handler] && ! Handler.instances[other.handler]
        1
      elsif Handler.instances[other.handler] && ! Handler.instances[handler]
        -1
      else
        frecency <=> other.frecency
      end
    end

    def frecency
      current = Time.now

      one_hour_ago = current - 3600
      one_day_ago = current - 86400
      one_week_ago = current - 604800

      if last_accessed > one_hour_ago
        multiplier = 4
      elsif last_accessed > one_day_ago
        multiplier = 2
      elsif last_accessed > one_week_ago
        multiplier = 0.5
      else
        multiplier = 0.25
      end

      rank * multiplier
    end

    def update_frecency
      self.rank += 1
      self.last_accessed = Time.now

      save
    end

  end
end
