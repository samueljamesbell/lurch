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
      return if event.message.nil? # TODO: Should perform this validation on event creation

      command_handled = ! event.command?

      Handler.rules.sort { |a, b| b <=> a}.each do |rule|
        pattern = Regexp.new(rule.pattern)
        matches = event.message.downcase.gsub(/[\'\".,]/, '').match(pattern)

        if matches
          handler = Handler.instances[rule.handler] ||=
                    Handlers::const_get(rule.handler).new

          handler.matches = matches
          handler.event = event

          message, status = handler.invoke(rule)
          status ||= :success

          unless status == :failure
            command_handled = true

            rule.update_frecency
            Handler.latest = rule.handler

            event = Event.new(rule.handler, 'sam', message, status)

            output(event.message) unless event.silent?
            Handler.server.accept(event)

            break
          end
        end
      end

      output(%Q{Sorry, I don't understand "#{event.message}"}) unless command_handled
    end

    private

    def self.output(message)
      Handler.server.send("#{message}\n")
    end

    public

    def invoke(rule)
      instance_eval(&rule.block)
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
