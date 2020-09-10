class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.string :pms

      t.timestamps
    end
  end
end
