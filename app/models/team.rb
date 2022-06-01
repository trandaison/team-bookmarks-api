class Team < ApplicationRecord
  mount_uploader :icon, ImageUploader

  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users
  has_many :owners, -> { where(team_users: { role: TeamUser.roles[:owner] }) }, through: :team_users, source: :user
  has_many :folders, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
end
