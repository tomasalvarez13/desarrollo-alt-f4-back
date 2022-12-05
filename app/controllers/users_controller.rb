# frozen_string_literal: true

# user controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  skip_before_action :authenticate_user, only: %i[create register index show]

  # GET /users
  def index
    users_list = []
    users = User.all
    users = users.where(['role = ?', params[:role]]) if params[:role]
    for user in users
        sum = 0 
        n = 0
        reviews = Review.where(['artist_id = ?',user.id])
        reviews.each do |review| 
            sum+=review.score
            n+=1
        end
        user_info = user.attributes.except("password_digest")
        @average = 0
        @average = sum/n if n>0
        user_info[:average] = @average
        users_list << user_info
    end
    render json: users_list, status: :ok
  end

  # GET /users/1
  def show
    render json: { error: 'No se ha encontrado el usuario' }, status: :not_found if @user.blank?
    return unless @user.present?
    if @user.artist?
      render json: @user.as_json(include: %i[posts artist_reviews artist_request], except: :password_digest), status: :ok 
    else
      render json: @user.as_json(include: %i[user_reviews user_request], except: :password_digest), status: :ok 
    end
  end

  # POST /users
  def create
    user = User.new(user_params)
    if user.save
      render json: user, except: [:password_digest], status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def register
    user = User.create!(user_params)
    render json: { accessToken: AuthenticationTokenService.generate_token(user.id), user: }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # PATCH/PUT /users/1
  def update
    render json: { error: 'No se ha encontrado el usuario' }, status: :not_found if @user.blank?
    return unless @user.present?

    render json: { error: 'Usuario no es actual' }, status: :unauthorized if @user != @current_user
    return unless @user == @current_user

    if @user.update!(user_params)
      render json: @user, except: [:password_digest], status: :accepted
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    render json: { error: 'No se ha encontrado el usuario' }, status: :not_found if @user.blank?
    return unless @user.present?

    if @current_user == @user || @current_user.admin?
      @user.destroy
      render status: :ok
    else
      render json: { error: 'No Autorizado' }, status: :unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def user_params
    params.permit(:id, :name, :lastname, :username, :password, :role)
  end

  def set_user
    @user = User.find(user_params[:id])
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  # Only allow a list of trusted parameters through.
end
