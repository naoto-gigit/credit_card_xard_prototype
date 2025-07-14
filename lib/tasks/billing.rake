# lib/tasks/billing.rake
namespace :billing do
  desc "Create monthly statements for all users"
  task create_statements: :environment do
    puts "Starting to create monthly statements..."

    User.find_each do |user|
      # このユーザーの最後の請求期間の終了日を取得
      # 存在しない場合は、1ヶ月前の初日をデフォルトとする
      last_statement_end_date = user.statements.order(billing_period_end_date: :desc).first&.billing_period_end_date || (Time.current.prev_month.beginning_of_month).to_date

      # 新しい請求期間を計算
      billing_period_start = (last_statement_end_date + 1.day).beginning_of_day
      billing_period_end = Time.current.end_of_month.end_of_day

      # 請求期間内に取引があるか確認
      transactions = Transaction.where(
        card_id: user.cards.pluck(:id),
        transacted_at: billing_period_start..billing_period_end
      )

      # 取引がなければ請求を作成しない
      next if transactions.empty?

      # 請求額を計算
      total_amount = transactions.sum(:amount)

      # 支払い期日を計算（例：翌月の10日）
      due_date = (Time.current.next_month.beginning_of_month + 9.days).to_date

      # 請求を作成
      Statement.create!(
        user: user,
        billing_period_start_date: billing_period_start.to_date,
        billing_period_end_date: billing_period_end.to_date,
        amount: total_amount,
        due_date: due_date,
        status: "pending"
      )

      puts "Created statement for user #{user.id} with amount #{total_amount}"
    end

    puts "Finished creating monthly statements."
  end
end
