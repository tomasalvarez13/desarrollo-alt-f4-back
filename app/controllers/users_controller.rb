# frozen_string_literal: true

# user controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  skip_before_action :authenticate_user, only: %i[create]

  # GET /users
  def index
    @users = User.all
    render json: @users, except: [:password_digest], status: :ok
  end

  # GET /users/1
  def show
    render json: { error: 'No se ha encontrado el usuario' }, status: :not_found if @user.blank?
    render json: @user, except: [:password_digest], status: :ok if @user.present?
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
