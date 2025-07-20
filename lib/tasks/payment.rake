# lib/tasks/payment.rake
namespace :payment do
  desc "Simulate payments for due statements and reactivate cards if all dues are cleared"
  task simulate_payments: :environment do
    puts "Starting to simulate payments..."

    # 支払期日を迎えた、支払い待ちまたは延滞中の請求を取得
    due_statements = Statement.where("due_date <= ?", Date.current).where(status: [ "pending", "overdue" ])

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

      # --- カード利用再開ロジック ---
      user = statement.user

      # ユーザーに他に延滞中の請求がないか確認
      unless user.statements.where(status: "overdue").exists?
        # 延滞がすべて解消されていたら、一時停止中のカードを有効化する
        user.cards.where(status: "suspended").each do |card|
          card.active!
          puts "Card #{card.id} has been reactivated."
        end
      end
    end

    puts "Finished simulating payments."
  end
end
