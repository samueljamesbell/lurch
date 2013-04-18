module Lurch
  class Rule < Sequel::Model

    attr_accessor :block

    set_primary_key [:handler, :pattern]
    unrestrict_primary_key

    def priority
      handler == 'Output' ? -1 : frecency
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

  end
end
