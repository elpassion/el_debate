class MobileUser < ApplicationRecord
  belongs_to :auth_token
  has_many :comments, as: :user

  validates :auth_token, presence: true
  validates :name, presence: true, unless: :edge?

  def image_url
    AvatarGenerator.new(auth_token.value).generate_url
  end

  private

  def edge?
    self.class.name.split('::')[0] == 'Edge'
  end
end
