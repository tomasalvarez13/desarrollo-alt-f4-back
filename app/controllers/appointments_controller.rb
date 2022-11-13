class AppointmentsController < ApplicationController
    before_action :set_appointment, only: %i[show update destroy]
    before_action :authenticate_user

    def index
        @appointments = Appointment.all
        render json: @appointments, status: :ok
    end

    def show
        render json: { error: 'No existe hora' }, status: :not_found if @appointment.blank?
        render json: @appointment, status: :ok if @appointment.present?
    end

    def create
        render json: { error: 'Usuario no es tatuador' }, status: :unauthorized if !@current_user.artist?
        return unless @current_user.artist?
        appointment = Appointment.new(appointment_params)
        appointment.user = @current_user
        if appointment.save
            render json: appointment, status: :created
        end
    end

    def update
        render json: { error: 'No existe cita' }, status: :not_found if @appointment.blank?
        return unless @appointment.present?
        render json: { error: 'Usuario no autorizado' }, status: :unauthorized if @appointment.user != @current_user 
        return unless @appointment.user == @current_user
        if @appointment.update(appointment_params)
            render json: @appointment, status: :accepted
        else
            render json: @appointment.errors, status: :unprocessable_entity
        end
    end

    def destroy
        render json: { error: 'No existe post' }, status: :not_found if @appointment.blank?
        return unless @appointment.present?
        if @appointment.user == @current_user || @current_user.admin?
            @appointment.destroy 
            render status: :ok
        else
            render json: { error: 'No Autorizado' }, status: :unauthorized
        end     
    end


    def appointment_params
        params.permit(:id, :descrption, :start_time, :end_time)
    end
    
    def set_appointment
        @appointment = Appointment.find(appointment_params[:id])
        rescue ActiveRecord::RecordNotFound
            @appointment = nil
    end



end
