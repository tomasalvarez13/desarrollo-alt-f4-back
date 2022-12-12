# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  enum :placement,
       %i[cabeza cuello manga hombro brazo pecho mano vientre costilla espalda pierna pie entero]
  validates  :price, :placement, :height, :width, :image_url, :title, :description, presence: true
end
