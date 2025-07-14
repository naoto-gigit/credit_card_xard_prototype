# frozen_string_literal: true

# StatementsHelper
module StatementsHelper
  # ステータスに応じてBootstrapのバッジクラスを返します。
  def status_badge_class(status)
    case status
    when "pending"
      "bg-warning text-dark"
    when "paid"
      "bg-success"
    when "overdue"
      "bg-danger"
    else
      "bg-secondary"
    end
  end
end
