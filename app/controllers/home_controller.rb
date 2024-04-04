class HomeController < ApplicationController
  before_action :authenticate_trader!, only: [:trader]
  before_action :authenticate_admin!, only: [:admin]
  def landing
  end

  def trader
  end

  def admin
  end
end
