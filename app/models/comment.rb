class Comment < ActiveRecord::Base
  enum status: [:pending, :accepted, :rejected]
  belongs_to :debate
  belongs_to :user

  validates :content, presence: true

  delegate :first_name, :last_name, :full_name, :initials_background_color, :initials,  to: :user, prefix: true
end
