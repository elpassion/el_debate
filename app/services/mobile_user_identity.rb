class MobileUserIdentity
  def call
    return if has_identity?
    mobile_user.update(
      first_name: params.fetch(:first_name),
      last_name:  params.fetch(:last_name)
    )
  end
  private

  attr_reader :mobile_user, :params

  def initialize(mobile_user, params)
    @mobile_user = mobile_user
    @params = params
  end

  def has_identity?
    mobile_user.first_name.present? && mobile_user.last_name.present?
  end
end
