# frozen_string_literal: true

json.users(@users) do |user|
  json.email user.email
  json.nickname user.nickname
end
