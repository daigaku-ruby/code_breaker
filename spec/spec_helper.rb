$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'code_breaker'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
