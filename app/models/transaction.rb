# frozen_string_literal: true

# frozen_string_literal: true

# Transaction
#
# クレジットカードの利用履歴を表すモデルです。
class Transaction < ApplicationRecord
  # 取引は一枚のカードに属します。
  belongs_to :card
  # カードを経由して、取引の所有者であるユーザーを取得します。
  has_one :user, through: :card
end
