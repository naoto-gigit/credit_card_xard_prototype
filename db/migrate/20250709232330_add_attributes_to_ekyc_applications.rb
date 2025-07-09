class AddAttributesToEkycApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :ekyc_applications, :company_name, :string
    add_column :ekyc_applications, :employment_type, :string
    add_column :ekyc_applications, :years_of_service, :integer
    add_column :ekyc_applications, :annual_income, :integer
    add_column :ekyc_applications, :other_debt, :integer
  end
end
