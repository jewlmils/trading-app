class AdminPagesController < ApplicationController
  before_action :require_admin
  before_action :set_trader, only: [:show, :edit, :update]

  def index
    @traders = Trader.where(approved: true)
  end

  def pending_traders
    @traders = Trader.where.not(confirmed_at: nil).where(approved: false)
  end  

  def show
  end

  def new
    @trader = Trader.new
  end

  def create
    @trader = Trader.new(trader_params.merge(admin_created: true, approved: true, confirmed_at: Time.zone.now))
    if @trader.save
      redirect_to admin_pages_path, notice: 'Trader was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @trader.update(trader_params)
      TraderMailer.account_approved_email(@trader).deliver_now if @trader.approved?
      redirect_to admin_pages_path, notice: 'Trader was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_trader
    @trader = Trader.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "You are not authorized to access this page." unless admin_signed_in?
  end

  def trader_params
    params.require(:trader).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin_created, :approved)
  end
end