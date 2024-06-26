# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < ApplicationController
      def index
        ballot = Ballot.find(params[:ballot_id])
        ballot_candidates = ballot.candidates
        candidates = ballot_candidates.map do |candidate|
          if candidate.image.attached?
            candidate.as_json.merge(image: url_for(candidate.image)).merge(votes: candidate.votes_for.size)
          else
            candidate.as_json.merge(votes: candidate.votes_for.size)
          end
        end

        render json: candidates
      end

      def show
        candidate = Candidate.find(params[:id])
        candidate = candidate.image.attached? ? candidate.as_json.merge(image: url_for(candidate.image)) : candidate.as_json
        render json: candidate
      end

      def create
        ballot_id = params[:ballot_id]
        first_name = params[:candidate][:first_name]
        last_name = params[:candidate][:last_name]
        Rails.logger.debug params
        image = params[:candidate][:file]
        candidate = Candidate.create(first_name:, last_name:)
        candidate.image.attach(image) if image != 'null'
        if candidate.save
          Rails.logger.debug(candidate.image.attached?)
          BallotCandidate.create!(ballot_id:, candidate_id: candidate.id)
          render json: { message: 'success' }
        else
          render json: { errors: candidate.errors.full_messages }
        end
      end

      def upvote
        candidate_id = params[:candidate_id]
        @candidate = Candidate.find(candidate_id)
        if current_user.already_voted?
          render json: { info: 'You already voted' }
        else
          @candidate.upvote_from current_user
          render json: { message: 'Vote Registered' }
        end
      end

      def update
        candidate = Candidate.find(params[:id])

        first_name = params[:candidate][:first_name]
        last_name = params[:candidate][:last_name]
        file = params[:candidate][:file]
        if candidate.image.attached?
          candidate.image.purge
          if candidate.update(first_name:, last_name:)
            candidate.image.attach(file) if image != 'null'
            candidate.save
            render json: { message: 'success' }
          else
            Rails.logger.debug candidate.errors.full_messages
            render json: { errors: candidate.errors.full_messages }
          end
        elsif candidate.update(first_name:, last_name:)

          candidate.image.attach(file) if file != 'null'
          candidate.save
          render json: { message: 'success' }
        end
      end

      def destroy
        Rails.logger.debug params
        ballot_id = params[:ballot_id]
        candidate_id = params[:id]

        ballot_candidate = BallotCandidate.where(ballot_id:, candidate_id:).first
        ballot_candidate.destroy
        render json: { message: 'Candidate deleted' }
      end
    end
  end
end
