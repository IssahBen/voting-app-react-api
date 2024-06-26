# frozen_string_literal: true

class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, fallback: :none
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role first_name last_name])
  end
end
