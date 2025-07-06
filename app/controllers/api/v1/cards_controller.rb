module Api
  module V1
    class CardsController < ApplicationController
      # CSRFトークンの検証をスキップ（APIのため）
      skip_before_action :verify_authenticity_token

      # カード発行APIのモック
      def issue
        # リクエストボディから必要なパラメータを取得（今回はモックなので使わないが、実際のAPIでは必要）
        # params[:user_id], params[:card_type] など

        # モックのレスポンスデータを生成
        # 実際のXard APIのレスポンスを模倣する
        response_data = {
          card_id: "mock_card_#{SecureRandom.hex(8)}", # ユニークなIDをシミュレート
          status: "issued",
          last_4_digits: "1234",
          card_type: "JCB",
          issued_at: Time.current.iso8601 # ISO 8601形式で日時を返す
        }

        # JSON形式でレスポンスを返す
        render json: response_data, status: :ok
      end
    end
  end
end
