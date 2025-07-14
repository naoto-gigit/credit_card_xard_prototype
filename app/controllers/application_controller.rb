# frozen_string_literal: true

# ApplicationController
#
# このコントローラは、アプリケーションの全てのコントローラの基底クラスです。
# 共通の処理や設定はここに記述します。
class ApplicationController < ActionController::Base
  # WebP画像、Web Push、バッジ、インポートマップ、CSSネスティング、CSS :has をサポートするモダンブラウザのみを許可します。
  allow_browser versions: :modern
end
