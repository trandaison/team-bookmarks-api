class TeamDetailSerializer < TeamSerializer
  has_many :owners

  has_many :folders do
    object.folders.where(parent_id: nil).order(:position)
  end

  has_many :bookmarks do
    object.bookmarks.where(folder_id: nil).order(:position)
  end
end
