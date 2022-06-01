class Folder < ApplicationRecord
  mount_uploader :icon, ImageUploader

  belongs_to :team
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :folders, class_name: Folder.name, foreign_key: :parent_id
  belongs_to :parent, class_name: Folder.name, foreign_key: :parent_id, optional: true

  enum sharing_mode: %i[shared nonpublic]
end
