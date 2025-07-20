# frozen_string_literal: true

# frozen_string_literal: true

# User
#
# アプリケーションのユーザーを表すモデルです。
# Deviseを利用した認証機能と、カードや申し込みに関する関連を定義します。
class User < ApplicationRecord
  # Deviseを使用して認証機能を設定します。
  # :database_authenticatable - パスワードをハッシュ化してDBに保存し、サインイン時にユーザーを検証します。
  # :registerable - ユーザー登録（サインアップ）を処理します。
  # :recoverable - パスワードをリセットし、リセット方法を通知します。
  # :rememberable - 保存されたCookieからユーザーを記憶します。
  # :validatable - emailとpasswordのバリデーションを提供します。
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーは所有者として複数のクレジットカードを持つことができます。
  has_many :cards, as: :owner
  # ユーザーは申込者として複数のカード申し込みを持つことができます。
  has_many :card_applications, as: :applicant
  # ユーザーは担当者として複数のカード申し込みを持つことができます。
  has_many :handled_card_applications, class_name: "CardApplication", foreign_key: "user_id"
  # ユーザーは法人に所属することができます。
  belongs_to :corporation, optional: true
  # ユーザーは複数の利用明細を持つことができます。
  has_many :statements
  # ユーザーはカードを通じて複数の取引を持つことができます。
  has_many :transactions, through: :cards
end
