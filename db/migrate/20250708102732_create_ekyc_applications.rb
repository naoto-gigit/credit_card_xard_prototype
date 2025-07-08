class CreateEkycApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :ekyc_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :document_type
      t.string :document_number
      t.string :full_name
      t.date :date_of_birth
      t.text :address

      t.timestamps
    end
  end
end
