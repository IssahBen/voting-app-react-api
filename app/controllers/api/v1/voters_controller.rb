class Api::V1::VotersController < ApplicationController
 

  # GET /voters
  def index
     ballot_id = params[:ballot_id]
     @ballot = Ballot.find(ballot_id)
     @voters = @ballot.voters

    render json: @voters
  end

  # GET /voters/1
  def show
   
    voter_id  = params[:id]
    @voter = Voter.find(voter_id)
    render json: @voter
  end

  # POST /voters
  def create
    first_name = params[:voter][:first_name]
    last_name = params[:voter][:last_name]
    email = params[:voter][:email]
    ballot_id = params[:ballot_id]
    @voter = Voter.new(first_name:first_name,last_name:last_name,email: email,ballot_id:ballot_id)

    if @voter.save
      render json: {message:"success"}, status: :created
    else
      render json: {errors:@voter.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /voters/1
  def update
    first_name = params[:voter][:first_name]
    last_name = params[:voter][:last_name]
    email = params[:voter][:email]
    if @voter.update(email:email,first_name:first_name,last_name:last_name)
      render json: {message:"success"}
    else
      render json: {errors:@voter.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /voters/1
  def destroy
    id = params[:id]
    @voter = Voter.find(id)
    @voter.destroy!
  end

   
end
