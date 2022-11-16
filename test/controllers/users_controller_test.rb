# frozen_string_literal: true

require 'test_helper'
class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = User.create(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
            password_digest: BCrypt::Password.create('santiago'))
        @authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))

    end

    test 'get users sin token' do
        get "/users"
        assert_response 401
    end

    test 'get users con token' do
        get "/users", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end
    
    test 'get user con token' do
        get "/users/#{@user.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'get user null con token' do
        get "/users/0", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :missing
    end

    test 'log in' do
        post "/authenticate", params: {username: "santiago@user.cl", password: "santiago" },as: :json
        assert_response :success
    end

    test 'sing in' do
        post "/register", params: {name: 'Fernando', lastname: 'Olivos', username: 'fernando@user.cl', role: 1, password: 'santiago' },as: :json
        assert_response :success
    end

    test 'sing in sin data' do
        post "/register", params: {name: 'Fernando', lastname: 'Olivos', role: 1, password: 'santiago' },as: :json
        # assert ActiveRecord::RecordInvalid: Validation failed: Username can't be blank
        assert_response 422
    end

    test 'edit user sin params' do
        patch "/users/#{@user.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response 422
    end

    test 'edit user' do
        patch "/users/#{@user.id}", params: {name: 'Fernando', lastname: 'Olivos', role: 1, password: 'santiago' },as: :json, headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'delete user sin token' do
        delete "/users/#{@user.id}"
        assert_response 401
    end

    test 'delete user' do
        delete "/users/#{@user.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

end    