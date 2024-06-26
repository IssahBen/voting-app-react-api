# frozen_string_literal: true

class CreateVoters < ActiveRecord::Migration[7.1]
  def change
    create_table :voters do |t|
      t.string :first_name
      t.string :last_name
      t.integer :ballot_id

      t.timestamps
    end
  end
end
