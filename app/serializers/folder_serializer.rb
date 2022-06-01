class FolderSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon, :position, :created_at, :updated_at

  has_one :parent
  belongs_to :team
  belongs_to :user
  has_many :bookmarks do
    object.bookmarks.order(:position)
  end
end
