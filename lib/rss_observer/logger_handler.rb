# frozen_string_literal: true

module RssObserver
  # Basic handler, outputting the memory change information to standard output
  class LoggerHandler
    KEY = :_rss_observer_initial_memory

    # @param logger [Logger]
    def initialize(logger = Logger.new(STDOUT))
      @logger = logger
    end

    # @param kilobytes [Float]
    def initial_memory(kilobytes)
      Thread.current[KEY] = kilobytes
    end

    # @param kilobytes [Float]
    def final_memory(kilobytes)
      initial_memory = Thread.current[KEY]
      return unless initial_memory

      change = kilobytes - initial_memory
      initial_memory(nil)
      logger.info "Memory change: #{change} KB"
    end

    private

    attr_reader :logger
  end
end
