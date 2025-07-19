# lib/tasks/transaction.rake

namespace :transaction do
  desc "Simulate a card transaction and send a webhook"
  task simulate: :environment do
    # 1. Find a random card to use
    card = Card.order(Arel.sql("RAND()")).first
    unless card
      puts "No cards found to simulate a transaction."
      return
    end

    # 2. Generate random transaction details
    merchant_name = [ "Amazon.co.jp", "Supermarket A", "Convenience Store B", "Gas Station C" ].sample
    amount = rand(100..10000)

    puts "Simulating transaction for Card ##{card.id} at #{merchant_name} for JPY #{amount}"

    # 3. Send a webhook to our own endpoint
    webhook_url = Rails.application.routes.url_helpers.webhooks_card_transactions_url(host: "localhost:3000")
    payload = {
      card_xard_id: card.xard_card_id,
      merchant_name: merchant_name,
      amount: amount,
      transacted_at: Time.current
    }.to_json

    begin
      uri = URI.parse(webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
      request.body = payload
      response = http.request(request)

      puts "Webhook sent successfully. Response: #{response.code}"
    rescue StandardError => e
      puts "Failed to send webhook: #{e.message}"
    end
  end
end
