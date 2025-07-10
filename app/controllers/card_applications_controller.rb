class CardApplicationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @card_application = CardApplication.new
  end

  def create
    @card_application = current_user.card_applications.build(card_application_params)

    if @card_application.save
      # ジョブをキューに追加
      EkycProcessingJob.perform_later(@card_application.id)
      redirect_to profile_path, notice: "eKYC申請を受け付けました。処理が完了次第、結果をお知らせします。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def card_application_params
    params.require(:card_application).permit(
      :document_type, :document_number, :full_name, :date_of_birth, :address,
      :company_name, :employment_type, :years_of_service, :annual_income, :other_debt
    )
  end
end
