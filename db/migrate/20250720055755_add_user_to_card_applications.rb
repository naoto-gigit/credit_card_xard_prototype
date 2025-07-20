# frozen_string_literal: true

class AddUserToCardApplications < ActiveRecord::Migration[8.0]
  def change
    add_reference :card_applications, :user, null: false, foreign_key: true
  end
end
