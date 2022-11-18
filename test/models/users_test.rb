# frozen_string_literal: true

require 'test_helper'
class UsersTest < ActiveSupport::TestCase
  test 'user sin params' do
    user = User.new
    assert !user.save
  end

  test 'create user' do
    user = User.new(name: 'Santiago', lastname: 'Olivos', username: 'santiago@user.cl', role: 2,
                    password_digest: BCrypt::Password.create('santiago'))
    assert user.save
  end
end
