require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'

use Rack::SslEnforcer, :except_environments => 'development'

app = Rack::Builder.app do
  map '/update_webhook_payload_doc' do
    run WebhookPayloadDocHandler.new
  end

  run Rack::Jekyll.new
end

run app
