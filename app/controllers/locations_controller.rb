# frozen_string_literal: true

class LocationsController < ApplicationController
  before_action :authorize_request

  def list
    @user_id = 1
    if @current_user
      @user_id = @current_user.id
    else
      render 'no_user', status: :ok, formats: [:json]
      return
    end
    @locations = Location.all.where(user_id: @user_id)
    @location_list = []
    @locations.each do |location|
      @location_list << {
        latlng: [location.lat, location.long],
        name: location.name,
        id: location.id
      }
    end
    render json: @location_list, status: :created
  end

  def list_other
    @user_id = 1
    if @current_user
      @user_id = @current_user.id
    else
      render json: { errors: 'No hay usuario ' }, status: :not_found
      return
    end
    @locations = Location.all.where(user_id: @user_id)
    @location_list = []
    @locations.each do |location|
      @location_list << {
        latlng: [location.lat, location.long],
        name: location.name,
        id: location.id
      }
    end
    @other_user_mail = ''
    @other_location_list = []
    if params[:email]
      @other_user_mail = params[:email]
      @other_user = User.where(email: params[:email]).first
      if @other_user

        @other_user_id = @other_user.id

        @other_locations = Location.all.where(user_id: @other_user_id)

        @other_locations.each do |location|
          @other_location_list << {
            latlng: [location.lat, location.long],
            name: location.name,
            id: location.id
          }
        end
      end
    end
    render json: @other_location_list , status: :ok
  end

  def location_params
    # params.require(:location).permit(:name, :lat, :long, :user_id)
    params.permit(:name, :lat, :long)
  end

  def new
    @user_id = @current_user.id if @current_user
    @location = Location.new
  end

  def create
    if location_params['name'] && location_params['lat'] && location_params['long']
      @location = Location.new(name: location_params['name'], lat: location_params['lat'], long: location_params['long'], user_id: @current_user.id)
      @message = ''
      @message = if @location.save
                   'Ubicación creeada exitosamente!'
                 else
                   'Hubo un error. Intenta nuevamente.'
                 end
      render json: @location, status: :created
    else
      render json: { errors: 'Faltan datos' }, status: :not_found
    end
  end

  def destroy
    @message = ''
    if params[:id]
      @location = Location.find(params[:id])
      if @location
        @location.destroy
        @message = 'Ubicacion eliminada exitosamente'
      else
        @message = 'No hay ubicacion con ese id'
      end
    else
      @message = 'No hay id'
    end
    render json: { message: @message }, status: :created
  end

  def all_users
    @users = User.all
    render json: @users, status: :created
  end
end
