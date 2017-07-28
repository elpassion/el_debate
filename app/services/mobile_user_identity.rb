class MobileUserIdentity
  def update(first_name:, last_name:)
    return if has_identity?
    mobile_user.update(
      first_name: first_name,
      last_name:  last_name
    )
  end
  private

  attr_reader :mobile_user

  def initialize(mobile_user)
    @mobile_user = mobile_user
  end

  def has_identity?
    mobile_user.first_name.present? && mobile_user.last_name.present?
  end
end
