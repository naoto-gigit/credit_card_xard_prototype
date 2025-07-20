class CorporationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @corporation = Corporation.new
  end

  def create
    @corporation = Corporation.new(corporation_params)

    if @corporation.save
      # ログイン中のユーザーを、作成した法人に紐付ける
      current_user.update(corporation: @corporation)
      redirect_to profile_path, notice: "法人情報が登録されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def corporation_params
    params.require(:corporation).permit(
      :name,
      :name_kana,
      :registration_number,
      :corporate_type,
      :establishment_date,
      :address,
      :phone_number,
      :website
    )
  end
end
