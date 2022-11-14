# frozen_string_literal: true

require 'test_helper'
class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = User.create(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
            password_digest: BCrypt::Password.create('santiago'))

    end

    def teardown
        User.destroy_all
    end

    test 'get users sin token' do
        get "/users"
        assert_response 401
    end

    test 'get users con token' do
        authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        get "/users", headers: { "HTTP_AUTHORIZATION" => authorization }
        assert_response :success
    end
    
    test 'get user con token' do
        authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        get "/users/#{@user.id}", headers: { "HTTP_AUTHORIZATION" => authorization }
        assert_response :success
    end

    test 'get user null con token' do
        authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        get "/users/0", headers: { "HTTP_AUTHORIZATION" => authorization }
        assert_response :missing
    end

    test 'sing in' do
        post "/authenticate", params: {username: "santiago@user.cl", password: "santiago" },as: :json
        assert_response :success
    end

end    