OpenAI.configure do |config|
  config.access_token = ENV.fetch("AZURE_OPENAI_API_KEY") { SecureRandom.hex }
  config.uri_base = ENV.fetch("AZURE_OPENAI_URI") { 'localhost' }
  config.api_type = :azure
  config.api_version = ENV.fetch("AZURE_API_VERSION") { '2023-05-15' }
end
