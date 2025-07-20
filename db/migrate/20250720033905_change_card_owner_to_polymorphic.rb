# frozen_string_literal: true

class ChangeCardOwnerToPolymorphic < ActiveRecord::Migration[8.0]
  def up
    # 開発環境のため、既存のカードデータをクリア
    Card.destroy_all if table_exists?(:cards)

    # user_idカラムを削除
    remove_reference :cards, :user, index: true if column_exists?(:cards, :user_id)

    # 新しいポリモーフィックなowner参照を追加
    add_reference :cards, :owner, polymorphic: true, null: false, index: true
  end

  def down
    # ロールバック処理
    remove_reference :cards, :owner, polymorphic: true, null: false, index: true

    # 古いuser参照を復元
    add_reference :cards, :user, null: false, foreign_key: true, index: true
  end
end
