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

      
       
  def update
    
    email = params[:user][:email]
    first_name = params[:user][:first_name]
    last_name = params[:user][:last_name]
    current_password = params[:user][:current_password]
    new_password = params[:user][:new_password]
    current_user = User.where(email:email).first
    if new_password == "" && current_user.valid_password?(current_password)
      current_user.update(email:email,first_name:first_name,last_name:last_name)
      if current_user.save 
        render json: {message:"success"}
      else
        render json:{errors:current_user.errors.full_messages}
      end
    end
    if new_password != "" && current_user.valid_password?(current_password)
      current_user.update(email:email,first_name:first_name,last_name:last_name,password: new_password)
      if current_user.save 
        render json: {message:"success"}
      else
        render json:{errors:current_user.errors.full_messages}
      end
    end
  end
    
end
