# frozen_string_literal: true

class BallotCandidate < ApplicationRecord
  belongs_to :ballot
  belongs_to :candidate
end
