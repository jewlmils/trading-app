class ApplicationController < ActionController::Base
    include Pagy::Backend
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
    def page_not_found
        flash[:alert] = "Looks like you've lost your way. Let's get you back on track."
        redirect_to root_path
    end
  
    def set_client
        iex_api_credentials = Rails.application.credentials.dig(:iex_api)
        
        @client = IEX::Api::Client.new(
            publishable_token: iex_api_credentials[:publishable_token],
            secret_token: iex_api_credentials[:secret_token],
            endpoint: 'https://cloud.iexapis.com/v1'
        )
    end
  
    private
  
    def record_not_found(exception)
        model_name = exception.model.constantize.model_name
        flash[:alert] = "Whoops, #{model_name} not found"
        redirect_to root_path
    end
end