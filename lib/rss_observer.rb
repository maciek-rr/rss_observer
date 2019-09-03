# frozen_string_literal: true

# Top level namespace of the Gem
module RssObserver
  Error = Class.new(StandardError)

  def self.current_memory
    @mem ||= GetProcessMem.new
    @mem.kb
  rescue StandardError
    nil
  end
end

require 'rss_observer/version'
require 'rss_observer/middleware'
