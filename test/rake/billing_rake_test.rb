require "test_helper"
require "rake"

class BillingRakeTest < ActiveSupport::TestCase
  def setup
    Rake.application.rake_require "tasks/billing"
    Rake::Task.define_task(:environment)
    @user = users(:one)
    @user_without_transactions = users(:two)
  end

  test "create_statements_task should create a new statement for users with transactions" do
    # 既存の請求書をクリア
    Statement.destroy_all

    # タスクを実行すると、取引のあるユーザー（one）の請求書が1件作成されることを確認
    assert_difference("User.find(#{@user.id}).statements.count", 1) do
      Rake::Task["billing:create_statements"].invoke
    end

    # 取引のないユーザー（two）の請求書は作成されないことを確認
    assert_no_difference("User.find(#{@user_without_transactions.id}).statements.count") do
      Rake::Task["billing:create_statements"].reenable # 同じタスクを再度実行するために必要
      Rake::Task["billing:create_statements"].invoke
    end
  end
end
