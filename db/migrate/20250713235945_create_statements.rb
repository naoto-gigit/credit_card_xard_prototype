class CreateStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :statements do |t|
      t.references :user, null: false, foreign_key: true
      t.date :billing_period_start_date
      t.date :billing_period_end_date
      t.integer :amount, null: false, default: 0
      t.date :due_date
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
    add_index :statements, :status
  end
end
