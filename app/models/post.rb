class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 5000 }

end
