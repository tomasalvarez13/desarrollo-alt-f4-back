# frozen_string_literal: true

include ActionView::Helpers::NumberHelper
class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]
  before_action :authenticate_user
  skip_before_action :authenticate_user, only: %i[index show]

  def index
    @posts = Post.all
    render json: @posts, status: :ok
  end

  def show
    render json: { error: 'No existe post' }, status: :not_found if @post.blank?
    render json: @post, status: :ok if @post.present?
  end

  def create
    render json: { error: 'Usuario no es tatuador' }, status: :unauthorized unless @current_user.artist?
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

  def filter_all
    @id = params[:id]
    @user_id = params[:user_id]
    @price_low = number_to_currency(params[:price_low])
    @price_high = number_to_currency(params[:price_high])
    @height_low = params[:height_low]
    @height_high = params[:height_high]
    @width_low = params[:width_low]
    @width_high = params[:width_high]
    @placement = params[:placement]
    @order = params[:order]
    @title = params[:title]

    @filter = Post.all
    @filter = @filter.where(['id = ?', @id]) if @id
    @filter = @filter.where(['user_id = ?', @user_id]) if @user_id
    @filter = @filter.where(['placement = ?', @placement]) if @placement
    @filter = @filter.where(['lower(title) LIKE ?', "%#{@title.downcase}%"]) if @title

    @filter = @filter.where(['price <= ? ', @price_high]) if @price_high
    @filter = @filter.where(['price >= ?', @price_low]) if @price_low
    @filter = @filter.where(['height <= ? ', @height_high]) if @height_high
    @filter = @filter.where(['height >= ?', @height_low]) if @height_low
    @filter = @filter.where(['width <= ? ', @width_high]) if @width_high
    @filter = @filter.where(['width >= ?', @width_low]) if @width_low

    @filter = @filter.order('price') if @order == 1
    @filter = @filter.order('price DESC') if @order == 2
    @filter = @filter.order('height') if @order == 3
    @filter = @filter.order('height DESC') if @order == 4
    @filter = @filter.order('width') if @order == 5
    @filter = @filter.order('width DESC') if @order == 6
    @filter = @filter.order('placement') if @order == 7
    @filter = @filter.order('placement DESC') if @order == 8
    @filter = @filter.order('user_id') if @order == 9
    @filter = @filter.order('user_id DESC') if @order == 10
    @filter = @filter.order('title') if @order == 11
    @filter = @filter.order('title DESC') if @order == 12

    render json: @filter, status: :ok
  end

  private

  def post_params
    params.permit(:id, :price, :placement, :height, :width, :image_url, :title, :description, :image_id, :user_id, :post)
  end

  def set_post
    @post = Post.find(post_params[:id])
  rescue ActiveRecord::RecordNotFound
    @post = nil
  end
end
