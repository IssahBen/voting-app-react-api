class Api::V1::BallotsController < ApplicationController
  before_action :set_ballot, only: %i[ show update destroy ]

  # GET /ballots
  def index
    @ballots = Ballot.all

    render json: @ballots
  end

  # GET /ballots/1
  def show

    render json: @ballot
  end

  # POST /ballots
  def create
    name = params[:ballot][:name]
    description = params[:ballot][:description]
    @ballot = Ballot.new(name:name,description:description)

    if @ballot.save
      render json: @ballot, status: :created
    else
      render json: @ballot.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ballots/1
  def update
    if @ballot.update(ballot_params)
      render json: @ballot
    else
      render json: @ballot.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ballots/1
  def destroy
    @ballot.destroy!
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
