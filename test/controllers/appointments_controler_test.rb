# frozen_string_literal: true

require 'test_helper'
class AppointmentsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = User.create(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
            password_digest: BCrypt::Password.create('santiago'))
        @authorization = ActionController::HttpAuthentication::Token.encode_credentials(AuthenticationTokenService.generate_token(@user.id))
        @appointment = Appointment.new(descrption: "long description", start_time: "2022-02-03T12:00:00+00:00", end_time: "2022-02-03T12:01:00+00:00")

    end

    test 'get appointments' do
        get "/appointments"
        assert_response 401
    end

    test 'get appointments con token' do
        get "/appointments", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'get appointment con token' do
        get "/appointments/#{@appointment.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'crear appointment con token' do
        post "/appointments",params: {descrption: "long description 2", start_time: "2022-02-03T12:00:00+00:00", end_time: "2022-02-03T12:01:00+00:00"},as: :json, headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'edit appointment' do
        patch "/appointments/#{@appointment.id}", params: {descrption: "long description", start_time: "2022-02-03T12:00:00+00:00", end_time: "2022-02-03T12:02:00+00:00"},as: :json, headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end

    test 'delete appointment' do
        delete "/appointments/#{@appointment.id}", headers: { "HTTP_AUTHORIZATION" => @authorization }
        assert_response :success
    end


end