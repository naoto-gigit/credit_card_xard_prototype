class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :statement, null: false, foreign_key: true
      t.integer :amount, null: false, default: 0
      t.datetime :paid_at

      t.timestamps
    end
  end
end
