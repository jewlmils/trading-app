class PagesController < ApplicationController
  before_action :redirect_signed_in_user, only: :landing
  before_action :require_trader, only: :trader

  def landing
  end

  def trader
  end

  private

  def redirect_signed_in_user
    if admin_signed_in?
      redirect_to admin_pages_path
    elsif trader_signed_in?
      redirect_to pages_trader_path
    end
  end

  def require_trader
    redirect_to admin_pages_path, alert: "The page you're trying to access is for traders only." unless trader_signed_in?
  end
end