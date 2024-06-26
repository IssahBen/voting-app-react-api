# frozen_string_literal: true

module Api
  module V1
    class VotingareaController < ApplicationController
      def pollinfo
        ballot_id = params[:ballot_id]
        ballot = Ballot.find(ballot_id)
        candidates = ballot.candidates.map do |candidate|
          if candidate.image.attached?
            candidate.as_json.merge(image: url_for(candidate.image)).merge(votes: candidate.votes_for.size)
          else
            candidate.as_json.merge(votes: candidate.votes_for.size)
          end
        end
        ballot_name = ballot.name

        render json: { name: ballot_name, candidates:, ballot_status: ballot.status }.as_json
      end
    end
  end
end
