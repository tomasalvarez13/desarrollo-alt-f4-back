# frozen_string_literal: true

require 'test_helper'
class ReviewsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @artist = User.create(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
                            password_digest: BCrypt::Password.create('santiago'))
        @user = User.create(name: 'Felipe', lastname: 'Olivos', username: 'sfelipeo@user.cl', role: 1,
                                password_digest: BCrypt::Password.create('felipe'))
        @authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        @review = Review.new(score: 5, coment: "de pana")
        @review.user = @user
        @review.artist = @artist
        @review.save
      end
    
      test 'get reviews sin token' do
        get '/reviews'
        assert_response 401
      end
    
      test 'get reviews con token' do
        get '/reviews', headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
      test 'get review con token' do
        get "/reviews/#{@review.id}", headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
      test 'crear reviews con token' do
        post '/reviews', params: { score: 5, coment: "de pana", artist_id: @artist.id}, as: :json,
                       headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end

      test 'crear reviews sin score' do
        post '/reviews', params: { coment: "de pana", artist_id: @artist.id}, as: :json,
                       headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response 422
      end
    
      test 'crear reviews sin data' do
        post '/reviews', params: { coment: "de pana" }, as: :json,
                       headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response 422
      end
    
      test 'edit review' do
        patch "/reviews/#{@review.id}",
              params: { score: 4, coment: "de pana" }, as: :json, headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
      test 'delete review sin token' do
        delete "/reviews/#{@review.id}"
        assert_response 401
      end
    
      test 'delete review' do
        delete "/reviews/#{@review.id}", headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
    end
    