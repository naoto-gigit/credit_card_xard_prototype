# lib/tasks/delinquency.rake
namespace :delinquency do
  desc "Check for overdue statements and update their status, and suspend user's cards"
  task check_overdue: :environment do
    puts "Checking for overdue statements..."

    # 支払期日を過ぎていて、まだ「支払い待ち」の請求を取得
    overdue_statements = Statement.where("due_date < ?", Date.current).where(status: "pending")

    overdue_statements.find_each do |statement|
      statement.update!(status: "overdue")
      puts "Statement #{statement.id} is now overdue."

      # 督促メールを送信します。
      DelinquencyMailer.overdue_reminder(statement).deliver_later

      # 利用者のカードを一時停止する
      statement.user.cards.each do |card|
        if card.active?
          card.suspended!
          puts "Card #{card.id} has been suspended."
        end
      end
    end

    puts "Finished checking for overdue statements."
  end
end
