class AddApprovedLimitToLimitIncreaseApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :limit_increase_applications, :approved_limit, :integer
  end
end
