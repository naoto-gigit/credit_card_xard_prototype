class Corporation < ApplicationRecord
  has_many :users
  has_many :card_applications, as: :applicant
  has_many :cards, as: :owner
end
