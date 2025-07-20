# frozen_string_literal: true

# CorporateCardApplicationsController
#
# このコントローラは、法人向けのクレジットカード申し込みに関連するリクエストを処理します。
class CorporateCardApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_corporation

  # GET /corporations/:corporation_id/card_applications/new
  def new
    @card_application = @corporation.card_applications.new
  end

  # POST /corporations/:corporation_id/card_applications
  def create
    @card_application = @corporation.card_applications.build(corporate_card_application_params)
    @card_application.user = current_user # 担当者を設定
    @card_application.status = "application_started" # 初期ステータスを設定

    if @card_application.save
      # KYB処理ジョブをキューに追加します。
      KybProcessingJob.perform_later(@card_application.id)
      redirect_to profile_path, notice: "法人カードの申し込みを受け付けました。審査が完了次第、結果をお知らせします。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_corporation
    # ログインユーザーが所属する法人のみを対象とする
    @corporation = current_user.corporation
    redirect_to root_path, alert: "法人情報が見つかりません。" unless @corporation && @corporation.id.to_s == params[:corporation_id]
  end

  def corporate_card_application_params
    # 法人申し込みに必要なパラメータを定義（個人とは異なる場合がある）
    # 現状は個人と同じだが、将来的に拡張する
    params.require(:card_application).permit(
      :document_type, :document_number, :full_name, :date_of_birth, :address,
      :company_name, :employment_type, :years_of_service, :annual_income, :other_debt
    )
  end
end
