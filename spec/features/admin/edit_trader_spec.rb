require 'rails_helper'
require 'support/login_helpers'

RSpec.describe 'Edit Trader', type: :feature do
  let!(:admin) { FactoryBot.create(:admin) } 

  include LoginHelpers

  before do
    login_as_admin(admin)
  end

  it 'allows admin to edit a trader' do
    trader = FactoryBot.create(:trader)

    visit admin_pages_path
    
    expect(page).to have_content(trader.email)

    click_link 'Edit'

    expect(page).to have_current_path(edit_admin_page_path(trader))

    fill_in "First name", with: "Updated First Name"
    fill_in "Last name", with: "Updated Last Name"
    fill_in "Email", with: "updated@example.com"

    click_button "Submit"

    expect(page).to have_content("Trader was successfully updated")
  end
end
