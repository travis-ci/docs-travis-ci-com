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

# API files path
api_root = File.expand_path('api', __dir__)
api_files = Rack::Files.new(api_root)

# API handler
api_app = lambda do |env|
  path = env['PATH_INFO'] || '/'

  # For the root of API, serve index file
  if path == '/' || path == ''
    index_file = File.join(api_root, 'index')
    if File.exist?(index_file)
      content = File.read(index_file)
      [200, { 'Content-Type' => 'text/html; charset=utf-8' }, [content]]
    else
      [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end
  else
    # Serve regular file
    return api_files.call(env)
  end
end

app = Rack::Builder.new do
  map '/update_webhook_payload_doc' do
    run PatchMethodOnly.new(nil)
  end

  map '/api' do
    run api_app
  end

  # default: serve static site with index.html fallback
  run static_app
end

run app
