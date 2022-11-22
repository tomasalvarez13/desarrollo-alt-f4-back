# frozen_string_literal: true

require 'test_helper'
class RequestsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @artist = User.create(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
                            password_digest: BCrypt::Password.create('santiago'))
        @user = User.create(name: 'Felipe', lastname: 'Olivos', username: 'sfelipeo@user.cl', role: 1,
                                password_digest: BCrypt::Password.create('felipe'))
        @authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        @request = Request.new(placement: 2,height:1, width:1, color: "blue", image_url:"image.png", current_state: "pendiente")
        @request.user = @user
        @request.artist = @artist
        @request.save
      end
    
      test 'get requests sin token' do
        get '/requests'
        assert_response 401
      end
    
      test 'get requests con token' do
        get '/requests', headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end

      #test 'get requests pendientes con token' do
      #  get '/requests', params: {state: "pendiente" }, as: :json, headers: { 'HTTP_AUTHORIZATION' => @authorization }
      #  assert_response :success
      #end
    
      test 'get request con token' do
        get "/requests/#{@request.id}", headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
      test 'crear requests con token' do
        post '/requests', params: { placement: 1,height:1, width:1, color: "black", image_url:"image2.png", artist_id: @artist.id, current_state: "pendiente"}, as: :json,
                       headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end

      test 'crear requests sin score' do
        post '/requests', params: { placement: 1, color: "blue", image_url:"image.png", artist_id: @artist.id}, as: :json,
                       headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response 422
      end
    
      test 'crear requests sin artist' do
        post '/requests', params: { placement: 2,height:1, width:1, color: "blue", image_url:"image.png"}, as: :json,
                       headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response 422
      end
    
      test 'edit request' do
        patch "/requests/#{@request.id}",
              params: { score: 4, coment: "de pana" }, as: :json, headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
      test 'delete request sin token' do
        delete "/requests/#{@request.id}"
        assert_response 401
      end
    
      test 'delete request' do
        delete "/requests/#{@request.id}", headers: { 'HTTP_AUTHORIZATION' => @authorization }
        assert_response :success
      end
    
end