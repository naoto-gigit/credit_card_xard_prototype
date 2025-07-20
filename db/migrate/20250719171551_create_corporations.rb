class CreateCorporations < ActiveRecord::Migration[8.0]
  def change
    create_table :corporations do |t|
      t.string :name
      t.string :name_kana
      t.string :registration_number
      t.string :corporate_type
      t.date :establishment_date
      t.text :address
      t.string :phone_number
      t.string :website

      t.timestamps
    end
    add_index :corporations, :registration_number, unique: true
  end
end
