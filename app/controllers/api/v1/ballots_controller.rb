class Api::V1::BallotsController < ApplicationController
  before_action :set_ballot, only: %i[ show update destroy ]

  # GET /ballots
  def index
    
    @ballots = current_user.ballots

    render json: @ballots
  end

  # GET /ballots/1
  def show

    render json: @ballot
  end

  # POST /ballots
  def create
    puts current_user
    name = params[:ballot][:name]
    description = params[:ballot][:description]
    @ballot = Ballot.new(name:name,description:description,user_id:current_user.id)

    if @ballot.save
      render json: {message:"success"}.as_json(), status: :created
    else
      render json: {errors:@ballot.errors}.as_json(), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ballots/1
  def update
    name = params[:ballot][:name]
    description = params[:ballot][:description]
    if @ballot.update(name:name,description:description)
      render json: {message:"successs"}
    else
      render json: {errors:@ballot.errors}, status: :unprocessable_entity
    end
  end

  def activate 
    ballot_id = params[:ballot_id]
    @ballot = Ballot.find(ballot_id)

    if @ballot.status == "inactive"
        @ballot.update(status: "active")
        @ballot.save
        render json: @ballot.as_json()
    else
      @ballot.update(status: "inactive")
      @ballot.save
      render json: @ballot.as_json()
    end

  end


  # DELETE /ballots/1
  def destroy
    @ballot.destroy!
    render json: {message: "success"}.as_json()
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot
      @ballot = Ballot.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ballot_params
      params.require(:ballot).permit(:name, :description, :user_id)
    end
end
