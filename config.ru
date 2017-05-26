require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'

use Rack::SslEnforcer, :except_environments => 'development'

app = Rack::Builder.app do
  map '/update_doc_webhook_payload' do
    run Handler.new
  end

  run Rack::Jekyll.new
end

run app
