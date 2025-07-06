class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :xard_card_id
      t.integer :user_id
      t.string :last_4_digits
      t.string :card_type
      t.string :status
      t.datetime :issued_at

      t.timestamps
    end
  end
end
