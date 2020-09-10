class Room < ApplicationRecord
  belongs_to :user
  has_many :messages
  has_many :permissions
  has_many :unread_messages

  mount_uploader :image, ImageUploader
end
