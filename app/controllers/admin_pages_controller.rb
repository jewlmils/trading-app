class AdminPagesController < ApplicationController
  before_action :require_admin

  def index
    @traders = Trader.all
  end

  def show
    @trader = Trader.find(params[:id])
  end

  private

  def require_admin
    unless admin_signed_in?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
