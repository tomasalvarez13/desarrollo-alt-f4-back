# frozen_string_literal: true

class User < ApplicationRecord
  # include TranslateEnum
  has_secure_password
  has_many :posts
  enum :role, [:admin, :client, :artist]
  validates :name, :lastname, :username, :role, presence: true
  validates :username, uniqueness: true
  # has_many :seats
end
