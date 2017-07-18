class Comment < ActiveRecord::Base
  belongs_to :debate
  belongs_to :user, polymorphic: true

  validates :content, presence: true

  delegate :image_url, :name, :first_name, :last_name, to: :user, prefix: true
end
