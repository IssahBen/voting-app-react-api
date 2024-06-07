class Api::V1::VotingareaController < ApplicationController

    def pollinfo
        ballot_id = params[:ballot_id]
        ballot = Ballot.find(ballot_id)
        candidates = []
        ballot.candidates.each do |candidate|
                 if candidate.image.attached?
                    candidates << candidate.as_json().merge(image: url_for(candidate.image))
               else
                 candidates << candidate.as_json()
               end
        end 
        ballot_name = ballot.name 

        render json: {name: ballot_name,candidates:candidates,ballot_status: ballot.status}.as_json
    end
end
