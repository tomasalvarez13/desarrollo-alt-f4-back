class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.integer :placement
      t.float :height
      t.float :width
      t.string :color
      t.string :image_url
      t.datetime :schedule_date
      t.datetime :request_date
      t.datetime :update_date
      t.string :current_state
      t.references :user, foreign_key: { to_table: 'users' }
      t.references :artist, foreign_key: { to_table: 'users' }
      t.timestamps
    end
  end
end
