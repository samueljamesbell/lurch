require_relative 'rule'


module Lurch

  class NoMatch < StandardError; end

  class Handler

    @rules = []

    class << self
      attr_accessor :rules
    end

    def self.inherited(subclass)
      subclass.define_singleton_method(:rule) do |pattern, &block|
        self.register_rule(subclass.name.split('::')[-1], pattern, &block)
      end
    end

    def self.match(event)
      Handler.rules.sort { |a, b| b.priority <=> a.priority }.each do |rule|
        pattern = Regexp.new(rule.pattern)
        matches = event.message.match(pattern)
        handler = Handlers::const_get(rule.handler).new

        unless matches.nil?
          begin
            handler.instance_exec(matches, &rule.block)

            rule.rank = rule.rank + 1
            rule.last_accessed = Time.now
            rule.save
          rescue NoMatch; end
        end
      end
    end

    def self.register_rule(handler, pattern, &block)
      rule = Rule[:pattern => pattern.to_s, :handler => handler] ||
             Rule.create(:pattern => pattern.to_s, :handler => handler, :rank => 0, :last_accessed => Time.now)

      rule.block = block
      Handler.rules << rule
    end

  end
end
