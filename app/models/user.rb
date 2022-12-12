# frozen_string_literal: true

class User < ApplicationRecord
  # include TranslateEnum
  has_secure_password
  has_many :posts # usuario artista
  has_many :appointments # usuatio artista

  has_many :user_request, class_name: "Request", foreign_key: "user_id"
  has_many :artist_request, class_name: "Request", foreign_key: "artist_id"

  has_many :user_reviews, class_name: "Review", foreign_key: "user_id"
  has_many :artist_reviews, class_name: "Review", foreign_key: "artist_id"

  enum :role, %i[admin client artist]
  validates :name, :lastname, :username, :role, presence: true
  validates :username, uniqueness: true
  validates :name, :lastname, format: { with: /\A[a-zA-Z]+\z/,
  message: "Solo puede contener letras" }
  # has_many :seats
end
