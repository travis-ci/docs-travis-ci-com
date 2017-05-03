require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'

use Rack::SslEnforcer, :except_environments => 'development'

run Rack::Jekyll.new
