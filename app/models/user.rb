# frozen_string_literal: true

class User < ApplicationRecord
  # include TranslateEnum
  has_secure_password
  has_many :posts # usuario artista
  has_many :appointments # usuatio artista

  has_many :user_request, class_name: "Request", foreign_key: "user_request_id"
  has_many :artist_request, class_name: "Request", foreign_key: "artist_request_id"

  has_many :user_reviews, class_name: "Reviews", foreign_key: "user_reviews_id"
  has_many :artist_reviews, class_name: "Reviews", foreign_key: "artist_reviews_id"

  enum :role, %i[admin client artist]
  validates :name, :lastname, :username, :role, presence: true
  validates :username, uniqueness: true
  # has_many :seats
end
