# lib/tasks/delinquency.rake
namespace :delinquency do
  desc "Check for overdue statements, update status, suspend cards, and calculate late payment charges"
  task :check_overdue, [ :date ] => :environment do |t, args|
    # 引数で日付が渡されればその日付を、なければ現在の日付を使用
    current_date = args[:date] ? Date.parse(args[:date]) : Date.current

    # --- 1. 新規延滞の検知とステータス更新 ---
    puts "Checking for new overdue statements..."
    # 支払期日を過ぎていて、まだ「支払い待ち」の請求を取得
    newly_overdue_statements = Statement.where("due_date < ?", current_date).where(status: "pending")

    newly_overdue_statements.find_each do |statement|
      statement.update!(status: "overdue")
      puts "Statement #{statement.id} is now overdue."

      # 督促メールを送信
      DelinquencyMailer.overdue_reminder(statement).deliver_later

      # 利用者のカードを一時停止
      statement.user.cards.active.each do |card|
        card.suspended!
        puts "Card #{card.id} has been suspended."
      end
    end
    puts "Finished checking for new overdue statements."

    # --- 2. 既存延滞に対する遅延損害金の計算 ---
    puts "Calculating late payment charges for existing overdue statements..."
    # ステータスが「延滞中」のすべての請求を取得
    existing_overdue_statements = Statement.where(status: "overdue")

    existing_overdue_statements.find_each do |statement|
      # 1日分の遅延損害金を計算
      daily_charge = statement.amount * LATE_PAYMENT_INTEREST_RATE / 365
      # 既存の損害金に加算
      statement.increment!(:late_payment_charge, daily_charge.round(2))
      puts "Added #{daily_charge.round(2)} to late payment charge for statement #{statement.id}. Total: #{statement.reload.late_payment_charge}"
    end
    puts "Finished calculating late payment charges."
  end
end
