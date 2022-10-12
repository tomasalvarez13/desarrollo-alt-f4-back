class AddAuth0TokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth0tkn, :string
  end
end
