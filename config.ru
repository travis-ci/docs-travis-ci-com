require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'
require 'rack/static'


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

  map '/api' do
    run lambda { |env|
      env['PATH_INFO'] = '/' if env['PATH_INFO'].to_s.empty?  # handle /api
      Rack::Static.new(-> { [404, {}, []] },
        urls: [''],
        root: File.expand_path('api', __dir__),
        index: 'index.html'
      ).call(env)
    }
  end

  run Rack::Jekyll.new
end

run app
