class Api::V1::SessionsController < ApplicationController
    def new
        parameter = params[:user]

        password = parameter[:password]
        email = parameter[:email]

        user = User.where(email:).first

        Rails.logger.debug(password)

        if user

          if user.valid_password?(password)

            render json: { token: user.authentication_token,user:user }
          else

            message_obj = { message: 'Wrong Password' }
            render json: message_obj.as_json
          end
        else
          message_obj = { message: 'Sign Up OR Check your email and password ' }
          render json:  message_obj.as_json
        end
      end

      def destroy
        Rails.logger.debug(current_user.authentication_token)
        current_user.authentication_token = Devise.friendly_token
        current_user.save
        Rails.logger.debug(current_user.authentication_token)
        render json: { message: 'Success' }
      end

      def signup; end
end
