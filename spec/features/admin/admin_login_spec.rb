require 'rails_helper'

RSpec.describe 'Admin login', type: :feature do
  let!(:admin) { FactoryBot.create(:admin) } # Create admin user

  it 'Admin logs in' do
    visit '/admins/sign_in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Submit'
    expect(page).to have_content 'Logout'
  end
end