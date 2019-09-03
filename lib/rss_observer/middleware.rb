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
      unless handler.respond_to?(:initial_memory)
        raise UnsupportedHandlerError, 'Handler must respond to the #initial_memory(kilobytes) method'
      end
      unless handler.respond_to?(:final_memory)
        raise UnsupportedHandlerError, 'Handler must respond to the #final_memory(kilobytes) method'
      end

      @handler = handler
    end

    # @param env [Hash] Full application environment hash
    # @return [Array] Status code, hash of headers, response body
    def call(env)
      handler.initial_memory(current_memory)
      app.call(env).tap do
        handler.final_memory(current_memory)
      end
    end

    private

    attr_reader :app, :handler

    def current_memory
      RssObserver.current_memory
    end
  end
end
