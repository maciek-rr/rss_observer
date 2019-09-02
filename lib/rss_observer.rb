# frozen_string_literal: true

# Top level namespace of the Gem
module RssObserver
  Error = Class.new(StandardError)
end

require 'rss_observer/version'
require 'rss_observer/middleware'
