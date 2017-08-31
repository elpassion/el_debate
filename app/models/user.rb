class User < ApplicationRecord
  belongs_to :auth_token
  has_many :comments, as: :user

  validates :auth_token, presence: true

  before_save :set_color

  def set_color
    self.initials_background_color = InitialsBackgroundColorGenerator.call
  end

  def full_name
    [first_name, last_name].compact.map { |name| name.strip.gsub(/^./, &:upcase) }.join(' ')
  end

  def initials
    [first_name, last_name]
      .map { |name_part| name_part[0].upcase if name_part.present? }
      .join
  end
end
