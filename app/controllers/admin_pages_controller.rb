class AdminPagesController < ApplicationController
  before_action :require_admin
  before_action :set_trader, only: [:show, :edit, :update]

  def index
    @traders = Trader.all
  end

  def show
  end

  def edit
  end

  def update
    if @trader.update(trader_params)
      redirect_to admin_pages_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end


  private

  def set_trader
    @trader = Trader.find(params[:id])
  end

  def require_admin
    unless admin_signed_in?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def trader_params
    params.require(:trader).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
