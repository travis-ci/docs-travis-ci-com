require 'net/http'
require 'base64'
require 'openssl'

class WebhookPayloadDocHandler
  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new(["Not found"], 404)

    return res unless req.post?

    payload = JSON.load(req.body.read)['payload'].to_json
    sig = Base64.decode64 env["HTTP_SIGNATURE"]

    config_data = JSON.load Net::HTTP.get(URI('https://api.travis-ci.org/config'))
    public_key = config_data["config"]["notifications"]["webhook"]["public_key"]

    pkey = OpenSSL::PKey::RSA.new(public_key)

    if pkey.verify(OpenSSL::Digest::SHA1.new, sig, payload)
      # do stuff
      res.body = ["Signature is valid"]
      res.status = 200
    else
      res.body = ["Signature is invalid"]
      res.status = 400
    end
    res
  end
end
