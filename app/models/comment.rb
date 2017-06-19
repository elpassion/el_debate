class Comment < ActiveRecord::Base
  belongs_to :debate
  validates :content, presence: true
  delegate :image_url, :name, to: :user, prefix: true
end
