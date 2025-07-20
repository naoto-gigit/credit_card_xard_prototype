class CreateLimitIncreaseApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :limit_increase_applications do |t|
      t.references :card, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :desired_limit
      t.date :start_date
      t.date :end_date
      t.string :reason
      t.string :status

      t.timestamps
    end
  end
end
