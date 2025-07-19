# frozen_string_literal: true

require "test_helper"

module Webhooks
  class CardTransactionsTest < ActionDispatch::IntegrationTest
    setup do
      @card = cards(:one)
    end

    test "should create transaction from webhook" do
      assert_difference("Transaction.count") do
        post webhooks_card_transactions_url, params: {
          card_xard_id: @card.xard_card_id,
          merchant_name: "Test Merchant",
          amount: 1000,
          transacted_at: Time.current
        }
      end

      assert_response :ok
      transaction = Transaction.last
      assert_equal @card.id, transaction.card_id
      assert_equal "Test Merchant", transaction.merchant_name
      assert_equal 1000, transaction.amount
    end

    test "should return not_found if card does not exist" do
      assert_no_difference("Transaction.count") do
        post webhooks_card_transactions_url, params: {
          card_xard_id: "non_existent_card_id",
          merchant_name: "Test Merchant",
          amount: 1000,
          transacted_at: Time.current
        }
      end

      assert_response :not_found
    end
  end
end
