class HomeController < ApplicationController
  # before_action :authenticate_trader!, only: [:trader]
  # before_action :authenticate_admin!, only: [:admin]

  before_action :require_admin, only: [ :admin]
  before_action :require_trader, only: :trader

  def landing
  end

  def trader
  end

  def admin
  end

  private

  def require_admin
    unless admin_signed_in?
      flash[:notice] = "You need to be an admin to access admin pages."
      redirect_to home_trader_path
    end
  end

  def require_trader
    unless trader_signed_in?
      flash[:notice] = "The page you're trying to access is for Traders only."
      redirect_to home_admin_path
    end
  end

end
