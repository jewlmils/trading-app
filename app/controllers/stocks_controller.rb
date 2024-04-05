class StocksController < ApplicationController
  before_action :set_client

  def index
    @symbols = @client.ref_data_symbols.map(&:symbol)
  end

  def show
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @price = @client.price(@symbol)
  end

  # def new
  # end

#   def create
#   end

#   def edit
#   end

#   def update
#   end

#   def destroy
#   end
end