require "test_helper"
require "rake"

class BillingRakeTest < ActiveSupport::TestCase
  def setup
    # Rakeアプリケーションをロード
    CreditCardXardPrototype::Application.load_tasks
    # テストデータをセットアップ
    @user = users(:one)
    # 既存のStatementをクリア
    Statement.destroy_all
  end

  test "create_statements task should create a new statement" do
    # 事前条件: Statementが存在しない
    assert_equal 0, Statement.count

    # タスクの実行
    Rake::Task["billing:create_statements"].invoke

    # 事後条件: Statementが1つ作成される
    assert_equal 1, Statement.count
    # 作成されたStatementの検証
    statement = Statement.first
    assert_equal @user, statement.user
    # トランザクションの合計額が正しいことを確認
    expected_amount = @user.transactions.sum(:amount)
    assert_equal expected_amount, statement.amount
    assert_equal "pending", statement.status
  end
end
