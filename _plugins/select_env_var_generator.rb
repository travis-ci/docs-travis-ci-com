# frozen_string_literal: true

ENVS = %w[
  WEBHOOK_PAYLOAD_GIST_ID
].freeze

class SelectEnvVarGenerator < Jekyll::Generator
  def generate(site)
    site.config['env'] = {}
    ENVS.each do |env|
      site.config['env'][env] = ENV[env]
    end
  end
end
