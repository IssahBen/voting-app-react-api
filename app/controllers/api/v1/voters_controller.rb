# frozen_string_literal: true

module Api
  module V1
    class VotersController < ApplicationController
      require 'csv'
      # GET /voters
      def index
        Rails.logger.debug params
        ballot_id = params[:ballot_id]
        @ballot = Ballot.find(ballot_id)
        @voters = @ballot.voters

        render json: @voters
      end

      # GET /voters/1
      def show
        voter_id = params[:id]
        @voter = Voter.find(voter_id)
        render json: @voter
      end

      # POST /voters
      def create
        first_name = params[:voter][:first_name]
        last_name = params[:voter][:last_name]
        email = params[:voter][:email]
        ballot_id = params[:ballot_id]
        @voter = Voter.new(first_name:, last_name:, email:, ballot_id:)

        if @voter.save
          render json: { message: 'success' }, status: :created
        else
          render json: { errors: @voter.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /voters/1
      def update
        first_name = params[:voter][:first_name]
        last_name = params[:voter][:last_name]
        email = params[:voter][:email]
        @voter = Voter.find(params[:id])
        if @voter.update(email:, first_name:, last_name:)
          render json: { message: 'success' }
        else
          render json: { errors: @voter.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def upload
        Rails.logger.debug params
        params[:ballot_id]
        cleaned_csv = clean_csv(params[:csv_file])
        Rails.logger.debug 10
        message = createvoters(cleaned_csv)
        if message == 'added'
          render json: { message: 'Voters Added successfully' }.as_json
        else
          render json: { errors: 'Your Record contains an already added voter.New voters were added' }.as_json
        end
      end

      # DELETE /voters/1
      def destroy
        id = params[:id]
        @voter = Voter.find(id)
        return unless @voter.destroy!

        render json: { message: 'success' }
      end

      private

      def clean_csv(file)
        csv = CSV.read(file)
        cleared_csv = csv.map(&:compact).reject(&:empty?)
        array = []
        cleared_csv.each_with_index do |row, i|
          next if i.zero?

          array << row
        end
        array
      end

      def createvoters(array)
        ballot_id = params[:ballot_id]
        begin
          array.each do |voter|
            first_name = voter[0]
            last_name = voter[1]
            email = voter[2]
            Voter.create(first_name:, last_name:, email:, ballot_id:)
          end
          'added'
        rescue Exception
          nil
        end
      end
    end
  end
end
