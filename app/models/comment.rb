class Comment < ActiveRecord::Base
  belongs_to :debate
  belongs_to :user, polymorphic: true

  validates :content, presence: true

  delegate :first_name, :last_name, :initials_background_color, :initials,  to: :user, prefix: true
end
