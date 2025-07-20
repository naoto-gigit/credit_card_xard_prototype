# frozen_string_literal: true

# Card
#
# 発行されたクレジットカードを表すモデルです。
class Card < ApplicationRecord
  # カードは一人の所有者（個人または法人）に属します。
  belongs_to :owner, polymorphic: true
  # カードは複数の取引を持つことができます。
  has_many :transactions
  # カードは複数の増額申請を持つことができます。
  has_many :limit_increase_applications

  # 現在有効な利用限度額を返す
  def current_credit_limit
    if temporary_limit.present? && temporary_limit_expires_at > Time.current
      temporary_limit
    else
      credit_limit
    end
  end
end
