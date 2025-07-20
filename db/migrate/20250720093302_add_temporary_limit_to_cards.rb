class AddTemporaryLimitToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :temporary_limit, :integer
    add_column :cards, :temporary_limit_expires_at, :datetime
  end
end
