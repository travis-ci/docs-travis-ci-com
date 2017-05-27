require 'faraday'
require 'base64'
require 'openssl'

class WebhookPayloadDocHandler
  DEFAULT_API_HOST = 'https://api.travis-ci.org'
  API_HOST = ENV.fetch('API_HOST', DEFAULT_API_HOST)

  def call(env)
    req = Rack::Request.new(env)
    gist_token = ENV['TRAVISBOT_GIST_TOKEN']
    payload_gist_id = ENV['WEBHOOK_PAYLOAD_GIST_ID']

    unless req.post? && gist_token && payload_gist_id
      return invalid_req_response
    end

    payload = URI.decode(req.params["payload"])
    sig = Base64.decode64 env["HTTP_SIGNATURE"]

    pkey = OpenSSL::PKey::RSA.new(public_key)

    unless pkey.verify(OpenSSL::Digest::SHA1.new, sig, payload)
      return invalid_sig_response
    end

    conn = Faraday.new(:url => "https://api.github.com") do |faraday|
      faraday.adapter Faraday.default_adapter
    end

    response = conn.patch "/gists/#{payload_gist_id}" do |req|
      req.headers["Content-Type"] = 'application/json'
      req.headers["Authorization"] = "token #{gist_token}"
      req.body = gist_update_body(payload)
    end

    if response.success?
      return valid_sig_response
    else
      return gist_update_failure_response
    end
  rescue
    Rack::Response.new(["Internal server error"], 500)
  end

  private
  def public_key
    return @public_key if @public_key

    conn = Faraday.new(:url => API_HOST) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
    response = conn.get '/config'
    @public_key = JSON.parse(response.body)["config"]["notifications"]["webhook"]["public_key"]
  rescue
    ''
  end

  def gist_update_body(payload)
    {
      "files" => {
        "webhookpayload.json" => {
          "content" => JSON.pretty_generate(JSON.load(payload))
        }
      }
    }.to_json
  end

  def invalid_req_response
    Rack::Response.new(
      [{"result" => "error", "message" => "Invalid request"}.to_json],
      400,
      {"Content-Type" => "application/json"}
    )
  end

  def invalid_sig_response
    Rack::Response.new(
      [{"result" => "error", "message" => "Signature is invalid"}.to_json],
      400,
      {"Content-Type" => "application/json"}
    )
  end

  def valid_sig_response
    Rack::Response.new(
      [{"result" => "success", "message" => "Signature is valid"}.to_json],
      200,
      {"Content-Type" => "application/json"}
    )
  end

  def gist_update_failure_response
    Rack::Response.new(
      [{"result" => "success", "message" => "Signature is valid, but gist update failed"}.to_json],
      200,
      {"Content-Type" => "application/json"}
    )
  end
end
