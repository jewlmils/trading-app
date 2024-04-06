class PagesController < ApplicationController
  before_action :redirect_signed_in_user, only: :landing
  before_action :require_approved_trader, only: :trader

  def landing
  end

  def trader
  end

  private

  def redirect_signed_in_user
    if admin_signed_in?
      redirect_to admin_pages_path
    elsif current_trader && current_trader.approved?
      redirect_to trader_path
    end
  end

  def require_approved_trader
    redirect_to root_path, alert: "Only approved traders can access this page." unless current_trader.approved?
  end
end