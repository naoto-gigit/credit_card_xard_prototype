require "test_helper"

module Webhooks
  class CardTransactionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @card = cards(:one)
      @params = {
        card_xard_id: @card.xard_card_id,
        merchant_name: "Test Merchant",
        amount: 1000,
        transacted_at: Time.current
      }
    end

    test "should create transaction for active card" do
      @card.active!

      assert_difference("Transaction.count", 1) do
        post webhooks_card_transactions_url, params: @params
      end

      assert_response :ok
    end

    test "should not create transaction for suspended card" do
      @card.suspended!

      assert_no_difference("Transaction.count") do
        post webhooks_card_transactions_url, params: @params
      end

      assert_response :unprocessable_entity
    end

    test "should return not_found if card does not exist" do
      @params[:card_xard_id] = "non_existent_id"

      assert_no_difference("Transaction.count") do
        post webhooks_card_transactions_url, params: @params
      end

      assert_response :not_found
    end
  end
end
