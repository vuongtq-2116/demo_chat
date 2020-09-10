class CreateUnreadMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :unread_messages do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.datetime :seen_at

      t.timestamps
    end
  end
end
