class AddUserAdmin < SeedMigration::Migration
  # change your admin email before run the application

  def up
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  end

  def down
    admin = AdminUser.find_by(email: 'admin@example.com')

    if admin.present?
      admin.destroy
    end
  end
end
