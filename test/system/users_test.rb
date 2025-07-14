require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "ユーザーがEmailとPasswordで新規登録し、ログイン・ログアウトできること" do
    # 1. トップページから新規登録ページへ
    visit root_url
    find("a", text: "新規登録").click
    assert_selector "h2", text: "新規登録"

    # 2. EmailとPasswordのみで登録
    fill_in "メールアドレス", with: "simple_user@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認用）", with: "password"

    assert_difference("User.count", 1) do
      within "form#new_user" do
        click_on "新規登録"
      end
    end

    # 登録後はトップページにリダイレクトされ、成功メッセージが表示される
    assert_text "ようこそ！アカウント登録が完了しました。"

    # 3. ログアウト
    assert_link "ログアウト"
    click_on "ログアウト"

    # ログアウト後はトップページにリダイレクトされ、成功メッセージが表示される
    assert_text "ログアウトしました。"

    # 4. ログインページへ
    assert_link "ログイン"
    click_on "ログイン"

    # 5. 登録した情報でログイン
    fill_in "メールアドレス", with: "simple_user@example.com"
    fill_in "パスワード", with: "password"
    click_on "ログイン"

    # ログイン後はトップページにリダイレクトされ、成功メッセージが表示される
    assert_text "ログインしました。"
  end
end
