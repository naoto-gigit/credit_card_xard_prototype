class Statement < ApplicationRecord
  belongs_to :user
  has_many :payments

  # 支払総額（請求額＋遅延損害金）を返す
  def total_due_amount
    amount + late_payment_charge
  end
end
