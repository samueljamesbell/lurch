require_relative 'rule'

module Lurch
  class Handler

    attr_accessor :server, :matches, :event

    @rules = []
    @instances = {}
    @latest = nil

    class << self
      attr_accessor :rules, :instances, :latest
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
      Handler.rules.sort { |a, b| b <=> a}.each do |rule|
        pattern = Regexp.new(".*#{rule.pattern}.*")
        matches = event.message.match(pattern)

        if matches
          handler = Handler.instances[rule.handler]

          unless handler
            handler = Handlers::const_get(rule.handler).new
            handler.server = server

            Handler.instances[rule.handler] = handler
          end

          handler.matches = matches
          handler.event = event

          status = catch(:halt) { handler.invoke(rule) }

          unless status == :failure
            rule.update_frecency
            Handler.latest = rule.handler
          end

          break if status == :success
        end
      end
    end

    def invoke(rule)
      instance_eval(&rule.block)
    end

    protected

    def succeed
      throw :halt, :success
    end

    def fail
      throw :halt, :failure
    end

    # TODO: Should not hardcode user to 'sam'
    def message(msg, opts = {})
      @server.accept(Event.new(self.class.to_s, 'sam', msg, opts))
    end

    def output(msg)
      message(msg, :bypass => true)
    end

    def silent(msg)
      message(msg, :silent => true)
    end

  end
end
