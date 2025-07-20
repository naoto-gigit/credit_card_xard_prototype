# frozen_string_literal: true

# frozen_string_literal: true

# CardApplication
#
# クレジットカードの申し込みを表すモデルです。
class CardApplication < ApplicationRecord
  # 申し込みは個人(User)または法人(Corporation)に属します。
  belongs_to :applicant, polymorphic: true
end
