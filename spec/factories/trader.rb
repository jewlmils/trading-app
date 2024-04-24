FactoryBot.define do
    factory :trader do
      first_name { 'John' }
      last_name { 'Doe' }
      email { 'john@example.com' }
      password { 'password' }
      approved { true }
    end
  end