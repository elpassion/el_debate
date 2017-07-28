class MobileUser < ApplicationRecord
  belongs_to :auth_token
  has_many :comments, as: :user

  validates :auth_token, presence: true

  before_save :set_color

  def set_color
    self.initials_background_color = InitialsBackgroundColorGenerator.call
  end

  def full_name
    [first_name, last_name].compact.map(&:strip).join(' ').titleize
  end

  def initials
    full_name.split.map(&:first).join
  end
end
