class EkycApplicationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @ekyc_application = EkycApplication.new
  end

  def create
    @ekyc_application = current_user.ekyc_applications.build(ekyc_application_params)

    if @ekyc_application.save
      # ジョブをキューに追加
      EkycProcessingJob.perform_later(@ekyc_application.id)
      redirect_to profile_path, notice: "eKYC申請を受け付けました。処理が完了次第、結果をお知らせします。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ekyc_application_params
    params.require(:ekyc_application).permit(:document_type, :document_number, :full_name, :date_of_birth, :address)
  end
end
