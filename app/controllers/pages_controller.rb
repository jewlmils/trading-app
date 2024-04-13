class PagesController < ApplicationController
  before_action :redirect_signed_in_user, only: :landing

  def landing
  end

  private

  def redirect_signed_in_user
    if admin_signed_in?
      redirect_to admin_pages_path
    elsif trader_signed_in?
      redirect_to trader_trader_dashboard_path
    end
  end
end
