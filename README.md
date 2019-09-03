# RssObserver

Rails middleware for observing of RSS changes around the request.

# Installation

Add the line
```gem 'rss_observer'```
to your Gemfile and run bundle install.

# Configuration

To use this middleware in a Rails application, modify relevant environment file (or application.rb to log rss in all environments).
You can use the supplied STDOUT logger and insert the RssObserver middleware after `Rails::Rack::Logger`.
```ruby
require 'rss_observer/logger'
module FooApp
  class Application < Rails::Application
    # ...
    config.middleware.insert_after Rails::Rack::Logger, RssObserver::Middleware, RssObserver::Logger.new
  end
end
```

More realistically, you'll need something more production-ready.
You can prepare a custom class that will make use of `Rails.logger`, that, with request_id in log tags will allow you to match
the usage log with actual request logs.

```ruby
# lib/rails_logger_handler.rb
class RailsLoggerHandler
  def call(kilobytes)
    Rails.logger.info "RSS change: #{kilobytes} KB"
  end
end

# config/application.rb
require_relative '../lib/rails_logger_handler'
module FooApp
  class Application < Rails::Application
    # ...
    config.log_tags = [:request_id]
    config.middleware.insert_after Rails::Rack::Logger, RssObserver::Middleware, RailsLoggerHandler.new
  end
end
```
