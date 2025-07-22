# frozen_string_literal: true

# CardApplicationsController
#
# このコントローラは、個人向けのクレジットカード申し込みに関連するリクエストを処理します。
class CardApplicationsController < ApplicationController
  # ユーザーがログインしていることを確認します。
  before_action :authenticate_user!

  # GET /card_applications/new
  # 新しいカード申し込みフォームを表示します。
  def new
    @card_application = CardApplication.new
  end

  # POST /card_applications
  # 新しいカード申し込みを作成します。
  def create
    @card_application = current_user.card_applications.build(card_application_params)
    @card_application.user = current_user # 担当者を設定
    @card_application.status = "application_started" # 初期ステータスを設定

    if @card_application.save
      # eKYC処理ジョブをキューに追加します。
      EkycProcessingJob.perform_later(@card_application.id)
      # プロフィールページにリダイレクトし、成功メッセージを表示します。
      redirect_to profile_path, notice: "eKYC申請を受け付けました。処理が完了次第、結果をお知らせします。"
    else
      # 保存に失敗した場合は、フォームを再表示します。
      render :new, status: :unprocessable_entity
    end
  end

  # GET /card_applications/:id
  # カード申し込みの詳細を表示します。
  def show
    @card_application = current_user.card_applications.find(params[:id])
  end

  private

  # カード申し込みのストロングパラメータを定義します。
  def card_application_params
    params.require(:card_application).permit(
      :document_type, :document_number, :full_name, :date_of_birth, :address,
      :company_name, :employment_type, :years_of_service, :annual_income, :other_debt
    )
  end
end
