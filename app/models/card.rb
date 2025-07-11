# frozen_string_literal: true

# frozen_string_literal: true

# Card
#
# 発行されたクレジットカードを表すモデルです。
class Card < ApplicationRecord
  # カードは一人のユーザーに属します。
  belongs_to :user
  # カードは複数の取引を持つことができます。
  has_many :transactions
end
