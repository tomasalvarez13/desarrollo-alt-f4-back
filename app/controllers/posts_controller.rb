class PostsController < ApplicationController
    before_action :set_post, only: %i[show update destroy]
    before_action :authenticate_user

    def index
        @posts = Post.all
        render json: @posts, status: :ok
    end

    def show
        render json: { error: 'No existe post' }, status: :not_found if @post.blank?
        render json: @post, status: :ok if @post.present?
    end

    def create
        render json: { error: 'Usuario no es tatuador' }, status: :unauthorized if !@current_user.artist?
        return unless @current_user.artist?
        image = params[:image_id]
        params = post_params.except(:image_id, :post)
        post = Post.new(params)
        post.user = @current_user

        if post.save
            render json: post, status: :created
        else
            render json: post.errors, status: :unprocessable_entity
        end
    end

    def update
        render json: { error: 'No existe post' }, status: :not_found if @post.blank?
        return unless @post.present?
        render json: { error: 'Usuario no dueño de post' }, status: :unauthorized if @post.user != @current_user 
        return unless @post.user == @current_user
        if @post.update(post_params)
            render json: @post, status: :accepted
        else
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    def destroy
        render json: { error: 'No existe post' }, status: :not_found if @post.blank?
        return unless @post.present?
        if @post.user == @current_user || @current_user.admin?
            @post.destroy 
            render status: :ok
        else
            render json: { error: 'No Autorizado' }, status: :unauthorized
        end     
    end

    private

    def post_params
        params.permit(:id, :price, :placement, :height, :width, :image_url, :image_id, :user_id, :post)
    end
    
    def set_post
        @post = Post.find(post_params[:id])
        rescue ActiveRecord::RecordNotFound
            @post = nil
    end
end
