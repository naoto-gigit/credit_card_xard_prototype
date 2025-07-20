# frozen_string_literal: true

# LimitIncreaseApplicationsController
#
# カード利用限度額の一時的な増額申請を処理するコントローラです。
class LimitIncreaseApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card

  # GET /cards/:card_id/limit_increase_applications/new
  def new
    @limit_increase_application = @card.limit_increase_applications.new
  end

  # POST /cards/:card_id/limit_increase_applications
  def create
    @limit_increase_application = @card.limit_increase_applications.build(limit_increase_application_params)
    @limit_increase_application.user = current_user
    @limit_increase_application.status = "pending"

    if @limit_increase_application.save
      # TODO: LimitIncreaseScoringJobを呼び出す
      redirect_to profile_path, notice: "限度額の一時増額を申請しました。審査結果をお待ちください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_card
    # ログインユーザーが所有するカードのみを��象とする
    @card = current_user.cards.find_by(id: params[:card_id])
    redirect_to root_path, alert: "対象のカードが見つかりません。" unless @card
  end

  def limit_increase_application_params
    params.require(:limit_increase_application).permit(
      :desired_limit, :start_date, :end_date, :reason
    )
  end
end
