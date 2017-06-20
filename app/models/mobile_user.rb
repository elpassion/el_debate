class MobileUser < ApplicationRecord
  has_many :mobile_comments, foreign_key: :id
  belongs_to :auth_token
  validates :username, :auth_token, presence: true

  alias_attribute :username, :name

  def image_url
    AvatarGenerator.new(auth_token.value).generate_url
  end
end

