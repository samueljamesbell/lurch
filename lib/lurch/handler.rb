require_relative 'rule'

module Lurch
  class Handler

    attr_accessor :matches, :event

    @rules = []
    @instances = {}
    @latest = nil
    @server = nil

    class << self
      attr_accessor :rules, :instances, :latest, :server
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

    def self.match(event)
      Handler.rules.sort { |a, b| b <=> a}.each do |rule|
        pattern = Regexp.new(rule.pattern)
        matches = event.message.downcase.gsub(/[\'\".,]/, '').match(pattern)

        if matches
          handler = Handler.instances[rule.handler] ||=
                    Handlers::const_get(rule.handler).new

          message, status = handler.invoke(rule, matches, event)

          unless status == :failure
            event.handled!

            rule.update_frecency
            Handler.latest = rule.handler

            new_event = Event.new(rule.handler, 'sam', message, status)
            Handler.server.accept(new_event)

            break
          end
        end
      end
    end

    def invoke(rule, matches, event)
      self.matches = matches
      self.event = event

      message, status = instance_eval(&rule.block)
      status ||= :success

      [message, status]
    end

    protected

    def question(msg)
      [msg, :question]
    end

    def silent(msg)
      [msg, :silent]
    end

    def failure(msg = '')
      [msg, :failure]
    end

  end
end
