class Post < ApplicationRecord
  belongs_to :user
  enum :placement, [:cabeza, :cuello, :manga, :hombro, :brazo, :pecho, :mano, :vientre, :costilla, :espalda, :pierna, :pie, :entero]
end
