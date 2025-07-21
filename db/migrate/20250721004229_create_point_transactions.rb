class CreatePointTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :point_transactions do |t|
      t.references :point_owner, polymorphic: true, null: false
      t.references :source_transaction, foreign_key: { to_table: :transactions }, null: true
      t.integer :points, null: false
      t.string :status, null: false, default: 'pending'
      t.text :external_api_response
      t.datetime :sent_at

      t.timestamps
    end
  end
end
