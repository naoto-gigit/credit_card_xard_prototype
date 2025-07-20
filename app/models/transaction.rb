# frozen_string_literal: true

# frozen_string_literal: true

# Transaction
#
# クレジットカードの利用履歴を表すモデルです。
class Transaction < ApplicationRecord
  # 取引は一枚のカードに属します。
  belongs_to :card
  # 取引はカードを通じて一人の所有者（個人または法人）に属します。
  delegate :owner, to: :card
end
