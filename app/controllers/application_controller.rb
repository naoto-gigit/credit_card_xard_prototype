# frozen_string_literal: true

# ApplicationController
#
# このコントローラは、アプリケーションの全てのコントローラの基底クラスです。
# 共通の処理や設定はここに記述します。
class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
