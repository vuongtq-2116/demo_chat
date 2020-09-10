class ChangeDataTypeForPmsPermissions < ActiveRecord::Migration[5.2]
  def change
    change_column(:permissions, :pms, :integer)
    change_column(:permissions, :status, :integer)
    change_column(:permissions, :pms, :integer)
  end
end
