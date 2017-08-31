class UserIdentity
  def update(first_name:, last_name:)
    return if has_identity?
    user.update(
      first_name: first_name,
      last_name:  last_name
    )
  end
  private

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def has_identity?
    user.first_name.present? && user.last_name.present?
  end
end
