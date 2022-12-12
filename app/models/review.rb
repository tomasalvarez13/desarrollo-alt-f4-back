class Review < ApplicationRecord
    belongs_to :user, class_name: "User"
    belongs_to :artist, class_name: "User"
    validates :score,:coment,:artist_id, presence: true
end
