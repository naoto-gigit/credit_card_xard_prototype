# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 開発用のログインユーザーを作成
User.find_or_initialize_by(email: 'a@d').tap do |user|
  user.password = 'p'
  user.password_confirmation = 'p'
  user.name = '開発 太郎'
  user.save(validate: false)
end

# --- 動作確認用の延滞データを作成 ---
user = User.first
if user
  puts "Creating overdue statement for user: #{user.email}"
  Statement.find_or_create_by!(user: user, due_date: Date.current.yesterday) do |s|
    s.billing_period_start_date = Date.current.prev_month.beginning_of_month
    s.billing_period_end_date = Date.current.prev_month.end_of_month
    s.amount = 15000
    s.status = "pending"
  end
  puts "Overdue statement created."
else
  puts "No users found. Skipping seed data creation."
end
