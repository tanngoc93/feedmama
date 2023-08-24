class AddUserAdmin < SeedMigration::Migration
  # change your admin email before run the application

  def up
    AdminUser.create!(
      email: 'admin@feedmama.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  def down
    AdminUser.find_by(email: 'admin@example.com')&.destroy
  end
end
