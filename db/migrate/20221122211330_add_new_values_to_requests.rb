class AddNewValuesToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :phone_number, :integer
  end
end
