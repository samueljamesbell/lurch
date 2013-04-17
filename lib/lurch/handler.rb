require_relative 'rule'

module Lurch
  class Handler

    @rules = []

    class << self
      attr_accessor :rules
    end

    def self.match(event)
      Handler.rules.sort_by { |r| r.priority }.each do |rule|
        # match each
        # params = matched chunks
        # rule.handler.new.instance_eval(rule.block)
        # if success, update frecency
      end
    end

    protected

    def self.rule(pattern, &block)
      rule = Rule[pattern, self.class] or Rule.create(:pattern => pattern, :handler => self.class)
      rule.block = block
      Handler.rules << rule
    end

  end
end
