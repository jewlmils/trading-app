# spec/support/login_helpers.rb

module LoginHelpers
    def login_as_admin(admin)
      visit '/admins/sign_in'
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Submit'
    end
  end
  