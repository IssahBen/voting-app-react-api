class  Api::V1::CandidatesController < ApplicationController

    def index 
       ballot = Ballot.find(params[:ballot_id]) 
       ballot_candidates = ballot.candidates 
       render json: ballot_candidates.as_json()
    end

    def show 
    end
    def create 

    end

    def update 
    end

end
