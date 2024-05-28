class Ballot < ApplicationRecord
    belongs_to :user 
    has_many :ballot_candidates, dependent: :destroy
    has_many :candidates, through: :ballot_candidates
end
