require_relative 'dispatch'

module Lurch
  class Handler

    attr_accessor :matches, :event

    def self.inherited(subclass)
      subclass.define_singleton_method(:rule) do |pattern, &block|
        Dispatch.register_rule(subclass.name.split('::')[-1], pattern, &block)
      end
    end

    def invoke(rule, matches, event)
      self.matches = matches
      self.event = event

      status = instance_eval(&rule.block) || :success

      status
    end

    protected

    # todo: don't know how these fit in anymore
    def question(msg)
      #TODO: return this, do something
      [msg, :question]
    end

    def silent(msg)
      [msg, :silent]
    end

    def direct(msg)
      [msg, :direct]
    end

    def failure(msg = '')
      [msg, :failure]
    end

  end
end
