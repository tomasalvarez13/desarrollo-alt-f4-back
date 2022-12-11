# frozen_string_literal: true

# application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token
  before_action :authenticate_user

  def not_found
    render json: { error: 'not_found' }
  end

  def authenticate_user
    token, _options = token_and_options(request)
    user_id = AuthenticationTokenService.decode_token(token)
    return head :unauthorized if user_id.blank?

    # @user = User.find(user_id)
    @current_user = User.find(user_id)
    return head :unauthorized if @current_user.blank?

    # params[:user_id] = @current_user.id
  end

  def me
    if @current_user.artist?
      render json: @current_user.as_json(include: %i[posts artist_reviews artist_request], except: :password_digest), status: :ok
    else
      render json: @current_user.as_json(include: %i[user_reviews user_request], except: :password_digest), status: :ok
    end
  end
end
