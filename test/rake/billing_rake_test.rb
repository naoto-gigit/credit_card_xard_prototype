require "test_helper"
require "rake"

class BillingRakeTest < ActiveSupport::TestCase
  def setup
    # Rakeタスクをロード
    CreditCardXardPrototype::Application.load_tasks
    # テスト対象のユーザーをセット
    @user = users(:one)
    # 既存のStatementをクリア
    Statement.destroy_all
  end

  test "create_statements task should create a new statement for users with transactions" do
    # 前提: ユーザーには今月の取引がある
    # (フィクスチャで定義済み)

    # タスクを実行すると、Statementが1件作成されることを確認
    assert_difference("Statement.count", 1) do
      Rake::Task["billing:create_statements"].invoke
    end

    # 作成されたStatementの主要な属性を確認
    statement = Statement.first
    assert_equal @user, statement.user
    assert_equal "pending", statement.status
  end
end
