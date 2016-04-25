class AuthToken < ApplicationRecord
  belongs_to :debate

  validates :debate_id, presence: true
  validates :value, presence: true, uniqueness: true

  before_validation :set_value

  private

  def set_value
    return if value.present?
    self.value = generate_value
  end

  def generate_value
    SecureRandom.uuid.gsub /\-/, ''
  end
end
