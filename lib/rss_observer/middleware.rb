# frozen_string_literal: true

require 'get_process_mem'

module RssObserver
  # Class containing the Rails Middleware that
  class Middleware
    UnsupportedHandlerError = Class.new(RssObserver::Error)

    # @param app [Object] Rails middleware instance
    # @param handler [Object] Handler that accepts memory change updates
    def initialize(app, handler)
      @app = app
      unless handler.respond_to?(:call)
        raise UnsupportedHandlerError, 'Handler must respond to the #call(kilobytes) method'
      end

      @handler = handler
    end

    # @param env [Hash] Full application environment hash
    # @return [Array] Status code, hash of headers, response body
    def call(env)
      before_memory = current_memory

      app.call(env).tap do
        memory_change = current_memory - before_memory
        handler.call(memory_change)
      end
    end

    private

    attr_reader :app, :handler

    def current_memory
      @mem ||= GetProcessMem.new
      @mem.kb
    end
  end
end
