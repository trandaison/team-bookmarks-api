class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon, :description, :pinned, :position, :created_at, :updated_at
end
