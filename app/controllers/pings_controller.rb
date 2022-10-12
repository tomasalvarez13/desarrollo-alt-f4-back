# frozen_string_literal: true

class PingsController < ApplicationController
  before_action :authorize_request

  def get_received
    @user_id = 1
    if @current_user
      @user_id = @current_user.id
    else
      render json: { errors: 'No hay usuario!' }, status: :not_found
      return
    end
    @pings = Ping.all.where(receiver_id: @user_id)
    @received_ping_list = []
    @pings.each do |ping|
      @received_ping_list << {
        ping_id: ping.id,
        sender_id: ping.sender_id,
        receiver_id: ping.receiver_id,
        approved: ping.approved
      }
    end
    render json: @received_ping_list, status: :created
  end

  def get_sended
    @user_id = 1
    if @current_user
      @user_id = @current_user.id
    else
      render json: { errors: 'No hay usuario' }, status: :not_found
      return
    end
    @pings = Ping.all.where(sender_id: @user_id)
    @sended_ping_list = []
    @pings.each do |ping|
      @sended_ping_list << {
        ping_id: ping.id,
        sender_id: ping.sender_id,
        receiver_id: ping.receiver_id,
        approved: ping.approved
      }
    end
    render json: @sended_ping_list, status: :created
  end

  def get_my_pings
    @user_id = 1
    if @current_user
      @user_id = @current_user.id
    else
      render json: { errors: 'No hay usuario' }, status: :not_found
      return
    end
    @sended_pings = Ping.all.where(sender_id: @user_id)
    @sended_ping_list = []
    @sended_pings.each do |ping|
      @sended_ping_list << {
        ping_id: ping.id,
        sender_id: ping.sender_id,
        receiver_id: ping.receiver_id,
        approved: ping.approved
      }
    end
    @received_pings = Ping.all.where(receiver_id: @user_id)
    @received_ping_list = []
    @received_pings.each do |ping|
      @received_ping_list << {
        ping_id: ping.id,
        sender_id: ping.sender_id,
        receiver_id: ping.receiver_id,
        approved: ping.approved
      }
    end
    render json: { sended: @sended_ping_list, received: @received_ping_list }, status: :created
  end

  def create
    if ping_params['receiver_id']
      @ping = Ping.new(sender_id: @current_user.id, receiver_id: ping_params['receiver_id'], approved: 0)
      @message = ''
      @message = if @ping.save
                   'Ping creeado exitosamente!'
                 else
                   'Hubo un error. Intenta nuevamente.'
                 end
      render json: { ping: @ping, message: @message }, status: :created
    else
      render json: { errors: 'Faltan datos' }, status: :not_found
    end
  end

  def approve
    @ping = Ping.where(id: ping_params[:ping_id]).first
    unless @ping.update_attribute(:approved, 1)
      render json: { errors: @ping.errors.full_messages },
             status: :unprocessable_entity
    end
    render json: { message: 'ping aprobado correctamente!!' }
  end

  def reject
    @ping = Ping.where(id: ping_params[:ping_id]).first
    unless @ping.update_attribute(:approved, 2)
      render json: { errors: @ping.errors.full_messages },
             status: :unprocessable_entity
    end
    render json: { message: 'ping rechazado correctamente!!' }
  end

  def ping_params
    params.permit(:ping_id, :receiver_id, :approved)
  end
end
