require 'rails_helper'
require 'support/login_helpers'

RSpec.describe 'Create Trader', type: :feature do
  let!(:admin) { FactoryBot.create(:admin) } 
  let(:trader_attributes) { FactoryBot.attributes_for(:trader) }

  include LoginHelpers

  before do
    login_as_admin(admin)
  end

  it 'allows admin to create a new trader' do
    visit '/admin'
    click_link 'Add New Trader'

    expect(page).to have_current_path('/admin/new')

    fill_in 'First name', with: trader_attributes[:first_name]
    fill_in 'Last name', with: trader_attributes[:last_name]
    fill_in 'Email', with: trader_attributes[:email]
    fill_in 'Password', with: trader_attributes[:password]

    click_button 'Submit'

    expect(page).to have_content 'Trader was successfully created'
  end
end
