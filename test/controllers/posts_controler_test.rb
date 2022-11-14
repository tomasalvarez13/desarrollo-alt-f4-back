# frozen_string_literal: true

require 'test_helper'
class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = User.create(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
            password_digest: BCrypt::Password.create('santiago'))
        @authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        @post = Post.new(price: 10, placement: 1, height: 1.0, width: 1.0, image_url: "www.url.org")
    end

    test 'get posts sin token' do
        get "/posts"
        assert_response 401
    end

    test 'get posts con token' do
        get "/posts", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'get post con token' do
        get "/posts/#{@post.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'crear posts con token' do
        post "/posts",params: {price: 10, placement: 1, height: 1.0, width: 1.0, image_url: 'www.url.org'},as: :json, headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'edit post' do
        patch "/posts/#{@post.id}", params: {price: 100, placement: 1, height: 1.0, width: 1.0, image_url: 'www.url.org'},as: :json, headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'delete post' do
        delete "/posts/#{@post.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end
end