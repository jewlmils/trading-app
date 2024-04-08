class StocksController < ApplicationController
  before_action :set_client

  def index
    if params[:search]
      @quote = search_stocks(params[:search])
      render :show
    end
  end

  def show
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @price = @client.price(@symbol)
  end

  private

  def search_stocks(keyword)
    quote = @client.quote(keyword)
    if quote != nil
      return quote
    else
      puts "No stock found"
    end
  end
end
