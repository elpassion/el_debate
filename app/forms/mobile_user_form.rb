class MobileUserForm < Reform::Form
  property :name
  property :auth_token

  validate :unique_name_for_debate?

  private

  def unique_name_for_debate?
    errors.add(:name, 'has to be unique') if auth_token.debate
                                                       .auth_tokens
                                                       .joins(:mobile_user)
                                                       .where('mobile_users.name = ?', name)
                                                       .any?
  end
end
