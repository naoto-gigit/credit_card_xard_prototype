class RenameEkycApplicationsToCardApplications < ActiveRecord::Migration[8.0]
  def change
    rename_table :ekyc_applications, :card_applications
  end
end
