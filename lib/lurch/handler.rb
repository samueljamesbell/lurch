require_relative 'rule'

module Lurch
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
      Handler.rules.sort_by { |r| r.priority }.each do |rule|
        pattern = Regexp.new(rule.pattern)
        matches = event.message.match(pattern)
        handler = Handlers::const_get(rule.handler).new
        handler.instance_eval(&rule.block) unless matches.nil?
        # params = matched chunks
        # if success, update frecency
      end
    end

    def self.register_rule(handler, pattern, &block)
      rule = Rule[:pattern => pattern.to_s, :handler => handler] ||
             Rule.create(:pattern => pattern.to_s, :handler => handler)

      rule.block = block
      Handler.rules << rule
    end

  end
end
