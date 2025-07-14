# lib/tasks/payment.rake
namespace :payment do
  desc "Simulate payments for due statements"
  task simulate_payments: :environment do
    puts "Starting to simulate payments..."

    # 支払期日を過ぎていて、まだ支払い待ちの請求を取得
    due_statements = Statement.where("due_date <= ?", Date.current).where(status: "pending")

    due_statements.find_each do |statement|
      # 支払いレコードを作成
      Payment.create!(
        statement: statement,
        amount: statement.amount,
        paid_at: Time.current
      )

      # 請求のステータスを「支払い済み」に更新
      statement.update!(status: "paid")

      puts "Simulated payment for statement #{statement.id}"
    end

    puts "Finished simulating payments."
  end
end
