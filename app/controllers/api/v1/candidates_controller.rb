class  Api::V1::CandidatesController < ApplicationController

    def index 
       ballot = Ballot.find(params[:ballot_id]) 
       ballot_candidates = ballot.candidates 
       render json: ballot_candidates.as_json()
    end

    def show 
       candidate = Candidate.find(params[:id])
        render json: candidate 

    end
    def create 
        ballot_id= params[:ballot_id]
        first_name = params[:candidate][:first_name]
        last_name = params[:candidate][:last_name]
        candidate=Candidate.create(first_name:first_name,last_name:last_name)
        if candidate.save
            ballot_candidate = BallotCandidate.create!(ballot_id:ballot_id,candidate_id:candidate.id)
            render json: {message:"success"}
        else 
            render json: {errors: candidate.errors.full_messages}
        end
    end

    def update 
        candidate = Candidate.find(params[:id])
        first_name = params[:candidate][:first_name]
        last_name = params[:candidate][:last_name]
        if candidate.update(first_name:first_name,last_name:last_name)
            candidate.save 
            render json: {message:"success"}
        else 
            puts candidate.errors.full_messages
            render json:  {errors:candidate.errors}
        end
        
    end

    def destroy
     puts params 
     ballot_id = params[:ballot_id]
     candidate_id = params[:id]

     ballot_candidate = BallotCandidate.where(ballot_id:ballot_id,candidate_id:candidate_id).first
     ballot_candidate.destroy
     render json: {message:"success"}
    end 

end
