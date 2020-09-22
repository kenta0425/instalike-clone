class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :users, through: :likes
  
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
                                      
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
