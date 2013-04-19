require_relative 'rule'

module Lurch
  class Handler

    attr_writer :server

    @rules = []

    class << self
      attr_accessor :rules
    end

    def self.inherited(subclass)
      subclass.define_singleton_method(:rule) do |pattern, &block|
        self.register_rule(subclass.name.split('::')[-1], pattern, &block)
      end
    end

    def self.register_rule(handler, pattern, &block)
      rule = Rule[:pattern => pattern.to_s, :handler => handler] ||
             Rule.create(:pattern => pattern.to_s, :handler => handler, :rank => 0, :last_accessed => Time.now)

      rule.block = block
      Handler.rules << rule
    end

    def self.match(event, server)
      Handler.rules.sort { |a, b| b.priority <=> a.priority }.each do |rule|
        pattern = Regexp.new(rule.pattern)
        matches = event.message.match(pattern)
        handler = Handlers::const_get(rule.handler).new
        handler.server = server

        unless matches.nil?
          handler.invoke(matches, &rule.block) and rule.update_frecency
        end
      end
    end

    def invoke(matches, &block)
      status = catch(:halt) { instance_exec(matches, &block) }

      status == :success
    end

    protected

    def fail
      throw :halt, :failure
    end

    # TODO: Should not hardcode user to 'sam'
    def message(msg, bypass = false)
      @server.accept(Event.new(self.class.to_s, 'sam', msg, bypass))
    end

    def output(msg)
      message(msg, true)
    end

  end
end
