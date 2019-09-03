# RssObserver

Rails middleware for observing of RSS changes around the request. Under the hood, it utilizes [the get_process_mem](https://github.com/schneems/get_process_mem) gem.

[![CircleCI](https://circleci.com/gh/irvingwashington/rss_observer.svg?style=svg)](https://circleci.com/gh/irvingwashington/rss_observer)


# Installation

Add the line
```gem 'rss_observer'```
to your Gemfile and run bundle install.

# Configuration

To use this middleware in a Rails application, modify relevant environment file (or application.rb to log rss in all environments).
You can use the supplied STDOUT logger and insert the RssObserver middleware after `Rails::Rack::Logger`.
```ruby
require 'rss_observer/logger_handler'
module FooApp
  class Application < Rails::Application
    # ...
    config.middleware.insert_after Rails::Rack::Logger, RssObserver::Middleware, RssObserver::LoggerHandler.new
  end
end
```

More realistically, you'll need something more production-ready.
You can prepare a custom class that will make use of `Rails.logger`, that, with request_id in log tags will allow you to match
the usage log with actual request logs.

```ruby
# lib/rails_logger_handler.rb
class RailsLoggerHandler
  def initial_memory(kilobytes)
    Thread.current[:_initial_memory] = kilobytes
  end

  def final_memory(kilobytes)
    Rails.logger.info "Memory change: #{final_memory - Thread.current[:_initial_memory]} KB"
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

# Example

RssObserver vs Default Rails request logs
```
I, [2019-09-03T14:56:22.735264 #7290]  INFO -- : [96956f1a-7f7f-4836-a8a1-bc3c05696433] Completed 200 OK in 47ms (Views: 29.7ms | ActiveRecord: 6.3ms | Allocations: 18614)
I, [2019-09-03T14:56:22.737113 #7290]  INFO -- : [96956f1a-7f7f-4836-a8a1-bc3c05696433] Memory change: 264.0 KB
```