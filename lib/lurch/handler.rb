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
      puts Handler.rules.inspect
      Handler.rules.sort_by { |r| r.priority }.each do |rule|
        # match each
        # params = matched chunks
        # rule.handler.new.instance_eval(rule.block)
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
