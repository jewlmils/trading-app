IEX::Api.configure do |config|
    iex_api_credentials = Rails.application.credentials.dig(:iex_api)
    config.publishable_token = iex_api_credentials[:publishable_token] # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
    config.secret_token = iex_api_credentials[:secret_token] # defaults to ENV['IEX_API_SECRET_TOKEN']
    config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end