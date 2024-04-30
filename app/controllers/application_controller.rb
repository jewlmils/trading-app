class ApplicationController < ActionController::Base
    include Pagy::Backend
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from IEX::Errors::SymbolNotFoundError,
                IEX::Errors::ClientError,
    with: :handle_iex_errors
  
    def page_not_found
        flash[:alert] = "Looks like you've lost your way. Let's get you back on track."
        redirect_to root_path
    end
  
    def set_client
        iex_api_credentials = Rails.application.credentials.dig(:iex_api)

        if iex_api_credentials.nil? || iex_api_credentials[:publishable_token].nil? || iex_api_credentials[:secret_token].nil?
            flash[:alert] = "Oops! Missing or incomplete IEX API credentials. Let's fix that!"
            redirect_to root_path
            return
        end
        
        @client = IEX::Api::Client.new(
            publishable_token: iex_api_credentials[:publishable_token],
            secret_token: iex_api_credentials[:secret_token],
            endpoint: 'https://cloud.iexapis.com/v1'
        )
    end
  
    private

    def handle_iex_error(e)
        case e
        when IEX::Errors::SymbolNotFoundError
            flash[:alert] = "Uh-oh! We couldn't find that symbol. Please check the symbol and try again."
            redirect_to stocks_path
        when IEX::Errors::ClientError
            if e.message.include?("Access is restricted to paid subscribers")
                flash[:alert] = "Oh no! IEX API access has been restricted. Upgrade for full service!"
            else
                flash[:alert] = "Oops! Something went wrong with IEX. Let's try again later!"
            end
            redirect_to root_path
        else
            flash[:alert] = "Oops! Something went wrong with IEX. Let's try again later!"
            redirect_to root_path
        end
    end
  
    def record_not_found(exception)
        model_name = exception.model.constantize.model_name
        flash[:alert] = "Whoops, #{model_name} not found"
        redirect_to root_path
    end
end