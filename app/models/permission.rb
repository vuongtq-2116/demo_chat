class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum pms: {owner: 1, user: 2}
  enum status: {requesting: 1, approved: 2}

  scope :except_owner, -> (uid){ where.not(user_id: uid)}
end
