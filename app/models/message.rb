class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }
  belongs_to :user
  belongs_to :room

  mount_uploader :image, ImageUploader
end
