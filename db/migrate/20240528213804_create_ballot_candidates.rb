# frozen_string_literal: true

class CreateBallotCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :ballot_candidates do |t|
      t.references :ballot, null: false, foreign_key: true
      t.references :candidate, null: false, foreign_key: true
      t.timestamps
    end
  end
end
