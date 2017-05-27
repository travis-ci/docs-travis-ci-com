require 'net/http'
require 'base64'
require 'openssl'

class WebhookPayloadDocHandler
  def call(env)
    req = Rack::Request.new(env)

    unless req.post?
      return Rack::Response.new(
        [{"result" => "error", "message" => "Invalid request"}.to_json],
        400,
        {"Content-Type" => "application/json"}
      )
    end

    payload = JSON.load(req.body.read)['payload'].to_json
    sig = Base64.decode64 env["HTTP_SIGNATURE"]

    config_data = JSON.load Net::HTTP.get(URI('https://api.travis-ci.org/config'))
    public_key = config_data["config"]["notifications"]["webhook"]["public_key"]

    pkey = OpenSSL::PKey::RSA.new(public_key)

    if pkey.verify(OpenSSL::Digest::SHA1.new, sig, payload)
      # do stuff
      Rack::Response.new(
        [{"result" => "success", "message" => "Signature is valid"}.to_json],
        200,
        {"Content-Type" => "application/json"}
      )
    else
      Rack::Response.new(
        [{"result" => "error", "message" => "Signature is invalid"}.to_json],
        400,
        {"Content-Type" => "application/json"}
      )
    end
  rescue
    Rack::Response.new(["Internal server error"], 500)
  end
end
