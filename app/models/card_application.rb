# frozen_string_literal: true

# frozen_string_literal: true

# CardApplication
#
# クレジットカードの申し込みを表すモデルです。
class CardApplication < ApplicationRecord
  # カード申し込みは一人のユーザーに属します。
  belongs_to :user
end
