class StocksController < ApplicationController
  before_action :require_trader
  before_action :set_client

  def index
    @major_stocks = fetch_major_stocks
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

  def fetch_major_stocks
    major_stocks = [
      { symbol: 'AAPL', name: 'Apple Inc.' },
      { symbol: 'SBUX', name: 'Starbucks Corp.' },
      { symbol: 'AMZN', name: 'Amazon.com Inc.' },
      { symbol: 'GOOGL', name: 'Alphabet Inc.' },
      { symbol: 'BA', name: 'Boeing Co.' },
      { symbol: 'NKE', name: 'Nike, Inc.' },
      { symbol: 'BRK.B', name: 'Berkshire Hathaway Inc.' },
      { symbol: 'HD', name: 'Home Depot, Inc.' }
    ]

    major_stocks.each do |stock|
      quote = @client.quote(stock[:symbol])
      stock[:price] = quote.latest_price if quote.present?
    end

    major_stocks
  end

  def search_stocks(keyword)
    @client.quote(keyword)
  rescue IEX::Errors::SymbolNotFoundError => e
    nil
  end

  def require_trader
    redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
  end
  
end