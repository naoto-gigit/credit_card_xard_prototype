class AddCreditScoreToCardApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :card_applications, :credit_score, :integer
  end
end
