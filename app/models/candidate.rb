# frozen_string_literal: true

class Candidate < ApplicationRecord
  before_save do
    self.first_name = first_name.strip.capitalize
    self.last_name = last_name.strip.capitalize
  end
  acts_as_votable
  has_many :ballot_candidates
  has_many :ballots, through: :ballot_candidates
  has_one_attached :image
  validates :first_name, presence: true
  validates :last_name, presence: true
end
