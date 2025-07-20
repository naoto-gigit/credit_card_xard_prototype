class AddCreditLimitToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :credit_limit, :integer
  end
end
