class AddLatePaymentChargeToStatements < ActiveRecord::Migration[8.0]
  def change
    add_column :statements, :late_payment_charge, :decimal, precision: 10, scale: 2, default: 0, null: false
  end
end
