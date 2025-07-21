class PointTransaction < ApplicationRecord
  belongs_to :point_owner, polymorphic: true
  belongs_to :source_transaction, class_name: "Transaction", optional: true
end
