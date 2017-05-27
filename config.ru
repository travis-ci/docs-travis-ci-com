require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'

use Rack::SslEnforcer, :except_environments => 'development'

class PatchMethodOnly
  def initialize app
    @app = app
  end

  def call env
    if Rack::Request.new(env).post?
      WebhookPayloadDocHandler.new.call(env)
    else
      Rack::Jekyll.new.call(env)
    end
  end
end

app = Rack::Builder.app do
  map '/update_webhook_payload_doc' do
    use PatchMethodOnly
  end

  run Rack::Jekyll.new
end

run app
