# frozen_string_literal: true

module RssObserver
  # Basic handler, outputting the memory change information to standard output
  class Logger
    # @param logger [Logger]
    def initialize(logger = Logger.new(STDOUT))
      @logger = logger
    end

    # @param kilobytes [Float]
    def call(kilobytes)
      logger.info "Memory change: #{kilobytes} KB"
    end

    private

    attr_reader :logger
  end
end
