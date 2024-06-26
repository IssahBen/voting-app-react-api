# frozen_string_literal: true

module Api
  module V1
    class BallotsController < ApplicationController
      before_action :set_ballot, only: %i[show update destroy]

      # GET /ballots
      def index
        @ballots = current_user.ballots

        render json: @ballots
      end

      # GET /ballots/1
      def show
        render json: { ballot: @ballot }.as_json
      end

      # POST /ballots
      def create
        Rails.logger.debug current_user
        name = params[:ballot][:name]
        description = params[:ballot][:description]
        @ballot = Ballot.new(name:, description:, user_id: current_user.id)

        if @ballot.save
          render json: { message: 'success' }.as_json, status: :created
        else
          render json: { errors: @ballot.errors.full_messages }.as_json
        end
      end

      # PATCH/PUT /ballots/1
      def update
        name = params[:ballot][:name]
        description = params[:ballot][:description]
        if @ballot.update(name:, description:)
          render json: { message: 'success' }
        else

          render json: { errors: @ballot.errors.full_messages }.as_json
        end
      end

      def activate
        ballot_id = params[:ballot_id]
        @ballot = Ballot.find(ballot_id)

        if @ballot.status == 'inactive'
          @ballot.update(status: 'active')
        else
          @ballot.update(status: 'inactive')
        end
        @ballot.save
        render json: @ballot.as_json
      end

      # DELETE /ballots/1
      def destroy
        @ballot.destroy!
        render json: { message: 'success' }.as_json
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
  end
end
