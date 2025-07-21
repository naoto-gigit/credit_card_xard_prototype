module ApplicationHelper
  def status_badge_class(status)
    case status
    when "pending"
      "secondary"
    when "sent"
      "success"
    when "failed"
      "danger"
    else
      "light"
    end
  end
end
