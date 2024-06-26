class  Api::V1::CandidatesController < ApplicationController

    def index 
       ballot = Ballot.find(params[:ballot_id]) 
       ballot_candidates = ballot.candidates 
       candidates = []
       ballot_candidates.each do |candidate|
           if candidate.image.attached?
            candidates << candidate.as_json().merge(image: url_for(candidate.image)).merge(votes:candidate.votes_for.size)
           else
            candidates << candidate.as_json().merge(votes:candidate.votes_for.size)
           end

       end
        
       render json: candidates
    end

    def show 
       candidate = Candidate.find(params[:id])
       candidate = candidate.image.attached? ? candidate.as_json().merge(image:url_for(candidate.image)): candidate.as_json()
        render json: candidate

    end
    def create 
        
        ballot_id= params[:ballot_id]
        first_name = params[:candidate][:first_name]
        last_name = params[:candidate][:last_name]
        puts params
        image = params[:candidate][:file]
        candidate=Candidate.create(first_name:first_name,last_name:last_name)
        if image != "null"
        
            candidate.image.attach(image)
        end
        if candidate.save
            puts(candidate.image.attached?)
            ballot_candidate = BallotCandidate.create!(ballot_id:ballot_id,candidate_id:candidate.id)
            render json: {message:"success"}
        else 
            render json: {errors: candidate.errors.full_messages}
        end
    end
    def upvote
        candidate_id = params[:candidate_id]
        @candidate = Candidate.find(candidate_id)
        if current_user.already_voted?
          render json: {info:'You already voted'}
        else
          @candidate.upvote_from current_user
          render json: {message: "Vote Registered"}
        end
      end

    def update 
        candidate = Candidate.find(params[:id])

        first_name = params[:candidate][:first_name]
        last_name = params[:candidate][:last_name]
        file = params[:candidate][:file]
        if candidate.image.attached?
            candidate.image.purge
            if candidate.update(first_name:first_name,last_name:last_name)
                if image != "null"
                candidate.image.attach(file)
                end 
                candidate.save 
                render json: {message:"success"}
            else 
                puts candidate.errors.full_messages
                render json:  {errors:candidate.errors.full_messages}
            end
        else 
            
            if candidate.update(first_name:first_name,last_name:last_name)
                if file != 'null'
                    candidate.image.attach(file)
                end 
                candidate.save 
                render json: {message:"success"}
            end
        end
    end

    def destroy
     puts params 
     ballot_id = params[:ballot_id]
     candidate_id = params[:id]

     ballot_candidate = BallotCandidate.where(ballot_id:ballot_id,candidate_id:candidate_id).first
     ballot_candidate.destroy
     render json: {message:"Candidate deleted"}
    end 

end
