require_relative 'rule'
require_relative 'handler'

module Lurch
  class Dispatch

    @rules = [];
    @instances = [];
    @latest = nil;

    class << self
      attr_accessor :rules, :instances, :latest
    end

    def self.register_rule(handler, pattern, &block)
      rule = Rule[:pattern => pattern.to_s, :handler => handler] ||
        Rule.create(:pattern => pattern.to_s, :handler => handler, :rank => 0, :last_accessed => Time.now)

      rule.block = block

      Dispatch.rules << rule
    end

    def self.send(event)
      Dispatch.rules.sort { |a, b| b <=> a}.each do |rule|
        pattern = Regexp.new(rule.pattern)
        matches = event.message.downcase.gsub(/[\'\".,]/, '').match(pattern)

        if matches
          handler = Dispatch.instances[rule.handler] ||=
                    Handlers::const_get(rule.handler).new

          status = handler.invoke(rule, matches, event)

          unless status == :failure
            event.handled!

            rule.update_frecency

            break
          end
        end
      end
    end
  end
end
