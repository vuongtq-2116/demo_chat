class AddStatusToPermission < ActiveRecord::Migration[5.2]
  def change
    add_column :permissions, :status, :string
  end
end
