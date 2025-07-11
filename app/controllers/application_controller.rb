# frozen_string_literal: true

# ApplicationController
#
# このコントローラは、アプリケーションの全てのコントローラの基底クラスです。
# 共通の処理や設定はここに記述します。
class ApplicationController < ActionController::Base
  # WebP画像、Web Push、バッジ、インポートマップ、CSSネスティング、CSS :has をサポートするモダンブラウザのみを許可します。
  allow_browser versions: :modern

  # Deviseコントローラが呼び出された場合に、`configure_permitted_parameters` メソッドを実行します。
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Deviseのストロングパラメータを設定します。
  # サインアップ時に `:name` パラメータを許可します。
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
