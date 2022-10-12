class ChangeDataTypeForApproved < ActiveRecord::Migration[5.2]
  def change
    change_column :pings, :approved, :integer, using: "approved::integer"
  end
end
