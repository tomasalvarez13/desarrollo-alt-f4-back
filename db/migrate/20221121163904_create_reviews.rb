class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :score
      t.text :coment
      t.string :image_url
      t.references :user, foreign_key: { to_table: 'users' }
      t.references :artist, foreign_key: { to_table: 'users' }
      t.timestamps
    end
  end
end
