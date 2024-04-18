class StocksController < ApplicationController
  before_action :require_trader
  before_action :set_client

  def index
    if params[:search]
      @search_keyword = params[:search]
      @quote = search_stocks(@search_keyword)
      if @quote.nil?
        redirect_to stocks_path, alert: "No stocks available for #{@search_keyword}"
      else
        render :show
      end
    end
  end

  def show
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
  end

  private

  def search_stocks(keyword)
    @client.quote(keyword)
  rescue IEX::Errors::SymbolNotFoundError => e
    nil
  end

  def require_trader
    redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
  end
  
end