class Bookmark < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :folder, optional: true
  enum sharing_mode: %i[shared nonpublic]
  enum bookmark_type: %i[url note]
end
