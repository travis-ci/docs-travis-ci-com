class SelectEnvVarGenerator < Jekyll::Generator
  ENVS = %w(
    WEBHOOK_PAYLOAD_GIST_ID
  )
  def generate(site)
    site.config['env'] = {}

    ENVS.each do |env|
      site.config['env'][env] = ENV[env]
    end
  end
end
