# frozen_string_literal: true

class AuthenticationController < ApplicationController
  # before_action :authorize_request, except: :login
  require 'json'

  # POST /auth/login
  # def login
  #   @user = User.find_by_email(params[:email])
  #   if @user&.authenticate(params[:password])
  #     token = JsonWebToken.encode(user_id: @user.id)
  #     time = Time.now + 24.hours.to_i
  #     render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
  #                    username: @user.username }, status: :ok
  #   else
  #     render json: { error: 'unauthorized' }, status: :unauthorized
  #   end
  # end

  # private

  # def login_params
  #   params.permit(:email, :password)
  # end

  # {"client_id":"I7MPRHXchKuBUVU89fJOOyyP4aSKgiwU","client_secret":"mxl8FKayy9yteFRNwMUNGAG7E-c2HkkMGNy-TGQU1z0FonAFza4j9ND2xVbxVzP8","audience":"https://dev-5br53tx9.us.auth0.com/api/v2/","grant_type":"client_credentials"}
  # domain
  def signup
    @email = params[:email]
    @password = params[:password]
    @response = HTTP.headers(accept: 'application/json').post(
      'https://dev-5br53tx9.us.auth0.com/dbconnections/signup',
      form: {
        client_id: 'I7MPRHXchKuBUVU89fJOOyyP4aSKgiwU',
        email: @email,
        password: @password,
        connection: 'Username-Password-Authentication'
      }
    )
    @data = JSON.parse(@response.body)
    if @data['statusCode']
      render json: @data['statusCode'], status: :unauthorized
    else
      @user = User.new(username: @email, email: @email, password: @password, password_confirmation: @password, auth0tkn: @data['_id'])
      Rails.logger.debug 'NEW'
      if @user.save

        render json: @data, status: :unauthorized
      else
        Rails.logger.debug @user.save
        Rails.logger.debug @user.errors.to_yaml
        render json: @user.errors, status: :unauthorized
      end

    end
  end

  def login
    @email = params[:email]
    @password = params[:password]
    @response = HTTP.headers(accept: 'application/x-www-form-urlencoded').post(
      'https://dev-5br53tx9.us.auth0.com/oauth/token',
      form: {
        grant_type: 'password',
        username: @email,
        password: @password,
        audience: 'https://dev-5br53tx9.us.auth0.com/api/v2/',
        client_id: 'I7MPRHXchKuBUVU89fJOOyyP4aSKgiwU',
        client_secret: 'mxl8FKayy9yteFRNwMUNGAG7E-c2HkkMGNy-TGQU1z0FonAFza4j9ND2xVbxVzP8'
      }
    )
    @data = JSON.parse(@response)
    @token = @data['access_token']
    @decoded = verify(@token)
    render json: { token: @token }, status: :unauthorized
  end
end
