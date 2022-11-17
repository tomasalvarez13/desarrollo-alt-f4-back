# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  enum :placement,
       %i[cabeza cuello manga hombro brazo pecho mano vientre costilla espalda pierna pie entero]
  validates :image_url, presence: true
end
