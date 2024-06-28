# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      # before_action :configure_sign_up_params, only: [:create]
      # before_action :configure_account_update_params, only: [:update]

      # GET /resource/sign_up
      # def new
      #   super
      # end

      # POST /resource
      def create
        user = params.require(:user)
        email = user[:email]
        password = user[:password]
        password_confirmation = user[:password_confirmation]
        first_name = user[:first_name]
        last_name = user[:last_name]

        role = user[:role]
        if role == 'official'
          @user = User.create(email:, password:, password_confirmation:,
                              first_name:, last_name:, role:)
          if @user.save
            render json: { token: @user.authentication_token, user: @user }
          else
            render json: { message: @user.errors.full_messages }.as_json
          end
        else
          ballot_id = check_eligibility(email, first_name, last_name)

          if ballot_id

            @user = User.create(email:, password:, password_confirmation:,
                                first_name:, last_name:, role:)
            if @user.save
              
              render json: { token: @user.authentication_token, user: @user, ballotId: ballot_id }.as_json
            else
              
              Rails.logger.debug @user.errors.full_messages
              render json: { message: 'Not a registered Voter' }.as_json
            end
          else
            render json: {message:"Not a registered voter"}

        end
      end

      private

      def check_eligibility(email, first_name, last_name)
        Voter.find_each do |voter|
          if email == voter.email && first_name == voter.first_name && last_name == voter.last_name
            return voter.ballot.id
          else
            return false
          end
        end
      end

      # GET /resource/edit
      # def edit
      #   super
      # end

      # DELETE /resource
      # def destroy
      #   super
      # end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      # def cancel
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_up_params
      #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
      # end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_account_update_params
      #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
      # end

      # The path used after sign up.
      # def after_sign_up_path_for(resource)
      #   super(resource)
      # end

      # The path used after sign up for inactive accounts.
      # def after_inactive_sign_up_path_for(resource)
      #   super(resource)
      # end
    end
  end
end
