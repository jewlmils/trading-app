class ApplicationController < ActionController::Base
    include Pagy::Backend

    def set_client
        iex_api_credentials = Rails.application.credentials.dig(:iex_api)
        
        @client = IEX::Api::Client.new(
            publishable_token: iex_api_credentials[:publishable_token],
            secret_token: iex_api_credentials[:secret_token],
            endpoint: 'https://cloud.iexapis.com/v1'
        )
    end
end