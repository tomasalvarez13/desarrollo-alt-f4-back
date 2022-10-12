# frozen_string_literal: true

class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    Rails.logger.debug 'LLAMO'
    @header = request.headers['Authorization']
    @header = @header.split(' ').last if @header
    if !@header
      render json: { errors: 'Missing token' }, status: :unauthorized
    else
      @verify = verify(@header)
      # render json: { errors: 'Internal Error' }, status: :unauthorized if @verify.zero?

    end
  end

  def verify(token)
    if token
      @to_return = JWT.decode(token, nil,
                              true, # Verify the signature of this token
                              algorithms: 'RS256',
                              iss: 'https://dev-5br53tx9.us.auth0.com/',
                              verify_iss: true,
                              aud: 'https://dev-5br53tx9.us.auth0.com/api/v2/',
                              verify_aud: true) do |header|
        jwks_hash[header['kid']]
      end
      @auth0tkn = @to_return[0]['sub'].split('|')[1]
      @current_user = User.find_by(auth0tkn: @auth0tkn)
      @auth0tkn
    else
      0
    end
  end

  def jwks_hash
    jwks_raw = Net::HTTP.get URI('https://dev-5br53tx9.us.auth0.com/.well-known/jwks.json')
    jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
    Hash[
      jwks_keys
      .map do |k|
        [
          k['kid'],
          OpenSSL::X509::Certificate.new(
            Base64.decode64(k['x5c'].first)
          ).public_key
        ]
      end
    ]
  end
end
