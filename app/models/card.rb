# frozen_string_literal: true

# frozen_string_literal: true

# Card
#
# 発行されたクレジットカードを表すモデルです。
class Card < ApplicationRecord
  # カードは一人の所有者（個人または法人）に属します。
  belongs_to :owner, polymorphic: true
  # カードは複数の取引を持つことができます。
  has_many :transactions
end
