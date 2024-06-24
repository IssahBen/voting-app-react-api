class User < ApplicationRecord
  acts_as_token_authenticatable
  acts_as_voter
  has_many :ballots
  def already_voted?
    candidates = Candidate.all
    candidates.each do |candidate|
      return true if voted_for? candidate
    end
    false
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

        
end
