class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :card, null: false, foreign_key: true
      t.string :merchant_name
      t.integer :amount
      t.datetime :transacted_at

      t.timestamps
    end
  end
end
