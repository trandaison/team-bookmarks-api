class Comment < ApplicationRecord
  belongs_to :blog, counter_cache: true
  belongs_to :user, optional: true

  validates :content, presence: true, length: { maximum: 5000 }, allow_nil: false

  scope :infinite_load, ->(cursor_id: nil, items: 20, direction: :desc) {
    (cursor_id ? where(direction == :desc ? 'id < ?' : 'id > ?', cursor_id) : all)
      .order(id: direction)
      .limit(items)
  }

  def soft_destroy
    self.update content: nil, deleted_at: Time.current
  end
end
