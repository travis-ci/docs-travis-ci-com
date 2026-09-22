require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'
require 'rack/static'

use Rack::SslEnforcer, :except_environments => 'development'

# Rack 3 requires lower-case header names. Normalize all response headers.
class HeaderDowncaser
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    normalized = {}
    headers.each do |k, v|
      # Ensure keys are lower-case strings; values must be strings (join arrays if any)
      normalized[k.to_s.downcase] = v.is_a?(Array) ? v.join("\n") : v.to_s
    end
    [status, normalized, body]
  end
end

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
  use HeaderDowncaser
  map '/update_webhook_payload_doc' do
    use PatchMethodOnly
  end

  map '/api' do
    run lambda { |env|
      # If the request is exactly /api (no trailing slash), redirect to /api/
      return [301, { 'location' => '/api/', 'content-type' => 'text/html' }, ['']] if env['PATH_INFO'].to_s.empty?

      env['PATH_INFO'] = '/' if env['PATH_INFO'] == '' # safety
      root = File.expand_path('api', __dir__)
      static = Rack::Static.new(-> { [404, {}, []] },
                                urls: [''],
                                root: root,
                                index: 'index.html')

      status, headers, body = static.call(env)

      # Fallback: if .css is requested but not found, try extensionless file and set proper content type
      if status == 404 && env['PATH_INFO'].end_with?('.css')
        rel = env['PATH_INFO'].sub(%r{^/}, '').sub(/\.css\z/, '')
        candidate = File.join(root, rel)
        if File.file?(candidate)
          css = File.binread(candidate)
          status = 200
          headers = {
            'content-type' => 'text/css',
            'content-length' => css.bytesize.to_s
          }
          body = [css]
        end
      end

      [status, headers, body]
    }
  end

  # Ensure icon fonts requested at site root resolve to the API build output
  map '/fonts' do
    run lambda { |env|
      root = File.expand_path('api/fonts', __dir__)
      static = Rack::Static.new(-> { [404, {}, []] },
                                urls: [''],
                                root: root)
      static.call(env)
    }
  end

  # Handle images with proper binary serving
  map '/user/images' do
    run lambda { |env|
      root = File.expand_path('_site/user/images', __dir__)
      static = Rack::Static.new(-> { [404, {}, []] },
                                urls: [''],
                                root: root)
      static.call(env)
    }
  end

  # Handle all other images
  map '/images' do
    run lambda { |env|
      root = File.expand_path('_site/images', __dir__)
      static = Rack::Static.new(-> { [404, {}, []] },
                                urls: [''],
                                root: root)
      static.call(env)
    }
  end

  run Rack::Jekyll.new
end

run app
