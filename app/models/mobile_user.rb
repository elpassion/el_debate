class MobileUser < ApplicationRecord
  belongs_to :auth_token
  has_many :comments, as: :user

  validates :auth_token, presence: true
  validates :name, presence: true, unless: :edge?

  before_save :set_color

  def set_color
    self.avatar_color = InitialsAvatarGenerator.call
  end

  def initials
    [self.first_name, self.last_name].compact.map { |s| s.first }.join(' ')
  end

  private

  def edge?
    self.class.name.split('::')[0] == 'Edge'
  end
end
