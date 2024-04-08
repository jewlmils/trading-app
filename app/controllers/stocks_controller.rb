class StocksController < ApplicationController
  before_action :set_client

  def index
    if params[:search]
      @search_keyword = params[:search]
      @quote = search_stocks(@search_keyword)
      if @quote != nil
        @error = false
        render :show
      else
        @error = true
        render :show
      end
    end
  end

  def show
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @price = @client.price(@symbol)
  end

  private

  def search_stocks(keyword)
    begin
      quote = @client.quote(keyword)
      return quote
    rescue IEX::Errors::SymbolNotFoundError => e
      puts "Symbol not found: #{keyword}"
      return nil
    end
  end
end
