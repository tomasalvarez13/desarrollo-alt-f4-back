class Request < ApplicationRecord
    enum :placement,
    %i[cabeza cuello manga hombro brazo pecho mano vientre costilla espalda pierna pie entero]
    belongs_to :user, class_name: "User"
    belongs_to :artist, class_name: "User"
    validates :placement,:height, :width, :color, :image_url, :artist_id, :current_state, presence: true
end
