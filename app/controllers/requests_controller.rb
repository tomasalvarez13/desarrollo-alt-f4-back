class RequestsController < ApplicationController
  before_action :set_request, only: %i[ show update destroy ]
  before_action :authenticate_user

  # GET /requests
  def index
    @requests = Request.all
    @requests = @requests.where(['current_state = ?', params[:state]]) if params[:state]
    @requests = @requests.where(['artist_id = ?', @current_user.id]) if @current_user.artist?
    @requests = @requests.where(['user_id = ?', @current_user.id]) if @current_user.client?
    render json: @requests.as_json(include: %i[user artist], except: :password_digest),
           status: :ok
  end

  # GET /requests/1
  def show
    render json: @request
  end
  

  # POST /requests
  def create
    puts request_params
    @request = Request.new(request_params)

    @request.user = @current_user
    
    if request_params[:artist_id]
      artist = User.find(request_params[:artist_id]) 
      render json: { error: 'Usuario no es tatuador' }, status: :unauthorized unless artist.artist?
      return unless artist.artist?
      @request.artist = artist
      if @request.save
        render json: @request, status: :created, location: @request
      else
        render json: @request.errors, status: :unprocessable_entity
        puts @request.errors.full_messages
      end
    else
      render json: @request.errors, status: :unprocessable_entity
      puts @request.errors.full_messages
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      render json: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(
        :placement, 
        :height, 
        :width, 
        :color, 
        :image_url, 
        :schedule_date,
        :request_date,
        :update_date, 
        :current_state, 
        :phone_number, 
        :description, 
        :user_id, 
        :artist_id
      )
      
    end
end
