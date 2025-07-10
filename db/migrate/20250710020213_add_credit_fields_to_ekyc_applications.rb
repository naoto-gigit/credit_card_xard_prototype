class AddCreditFieldsToEkycApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :ekyc_applications, :credit_limit, :integer
    add_column :ekyc_applications, :credit_decision, :string
  end
end
