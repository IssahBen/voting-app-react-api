# frozen_string_literal: true

class Ballot < ApplicationRecord
  belongs_to :user
  has_many :voters, dependent: :destroy
  has_many :ballot_candidates, dependent: :destroy
  has_many :candidates, through: :ballot_candidates
  validates :name, presence: true
  validates :description, presence: true
end
