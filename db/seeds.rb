admin = Admin.where(email:"admin@email.com").first_or_initialize
admin.update!(
    password:"password",
    password_confirmation: "password"
)