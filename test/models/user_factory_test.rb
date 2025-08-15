require "test_helper"

class UserFactoryTest < ActiveSupport::TestCase
  test "factory_botを使った基本的なユーザー作成" do
    user = create(:user)
    assert user.persisted?
    assert user.valid?
    assert_match /user\d+@example\.com/, user.email
  end

  test "法人所属ユーザーの作成" do
    user = create(:user, :corporate)
    assert user.persisted?
    assert user.corporation.present?
    assert_instance_of Corporation, user.corporation
  end

  test "ユーザーにカードを作成" do
    user = create(:user)
    card = create(:card, owner: user)

    assert_equal user, card.owner
    assert_includes user.cards, card
  end

  test "ユーザーに取引履歴を作成" do
    user = create(:user)
    card = create(:card, owner: user)
    transaction = create(:transaction, card: card)

    assert_includes user.transactions, transaction
  end

  test "一時増額中のカードを持つユーザー" do
    user = create(:user)
    card = create(:card, :with_temporary_limit, owner: user)

    assert_equal 100, card.current_credit_limit
    assert card.temporary_limit_expires_at > Time.current
  end
end
