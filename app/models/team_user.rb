class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :invited_by, class_name: User.name, foreign_key: :invited_by_id, optional: true

  enum role: %i[owner member guest]
end
