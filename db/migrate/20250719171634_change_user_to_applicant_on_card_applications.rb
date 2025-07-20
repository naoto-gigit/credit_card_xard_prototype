class ChangeUserToApplicantOnCardApplications < ActiveRecord::Migration[8.0]
  def change
    # applicant_id と applicant_type カラムを追加
    add_reference :card_applications, :applicant, polymorphic: true, null: true, index: true

    # 既存の user_id を新しい applicant カラムに移行する処理（データがある場合）
    # reversible do |dir|
    #   dir.up do
    #     CardApplication.where.not(user_id: nil).find_each do |app|
    #       app.update_columns(applicant_type: 'User', applicant_id: app.user_id)
    #     end
    #   end
    # end

    # user_id カラムを削除
    remove_reference :card_applications, :user, foreign_key: true, index: true
  end
end
