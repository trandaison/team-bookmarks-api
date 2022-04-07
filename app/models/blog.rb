# frozen_string_literal: true

class Blog < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 5000 }
end
