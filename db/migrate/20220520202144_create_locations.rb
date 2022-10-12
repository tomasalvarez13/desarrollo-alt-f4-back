class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.integer :user_id
      t.decimal :lat
      t.decimal :long
      t.string :name

      t.timestamps
    end
  end
end
