class HomeController < ApplicationController
  before_action :redirect_signed_in_user, only: :landing
  before_action :require_admin, only: :admin
  before_action :require_trader, only: :trader

  def landing
  end

  def trader
  end

  def admin
    @traders = Trader.all
  end

  private

  def redirect_signed_in_user
    if admin_signed_in?
      redirect_to home_admin_path
    elsif trader_signed_in?
      redirect_to home_trader_path
    end
  end

  def require_admin
    return if admin_signed_in?

    flash[:alert] = "You need to be an admin to access admin pages."
    redirect_to home_trader_path
  end

  def require_trader
    return if trader_signed_in?

    flash[:alert] = "The page you're trying to access is for traders only."
    redirect_to home_admin_path
  end

end
