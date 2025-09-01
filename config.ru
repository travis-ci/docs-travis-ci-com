require 'yaml'
require 'rack-ssl-enforcer'
require 'rack'
require_relative '_plugins/webhoook_payload_doc_handler'

use Rack::SslEnforcer, :except_environments => 'development'

class PatchMethodOnly
  def initialize app
    @app = app
  end

  def call env
    if Rack::Request.new(env).post?
      WebhookPayloadDocHandler.new.call(env)
    else
      Rack::Files.new(File.expand_path('_site', __dir__)).call(env)
    end
  end
end

root = File.expand_path('_site', __dir__)
files = Rack::Files.new(root)

# Simple static server with index.html fallback
static_app = lambda do |env|
  path = env['PATH_INFO'] || '/'

  # Try exact path first
  status, headers, body = files.call(env)
  return [status, headers, body] unless status == 404

  # Try index.html for root and directories
  if path == '/' || path.end_with?('/')
    env2 = env.dup
    env2['PATH_INFO'] = File.join(path, 'index.html')
    return files.call(env2)
  end

  # Not found
  [status, headers, body]
end

app = Rack::Builder.app do
  map '/update_webhook_payload_doc' do
    use PatchMethodOnly
  end

  # default: serve static site with index.html fallback
  run static_app
end

run app
