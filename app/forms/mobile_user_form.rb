class MobileUserForm < Reform::Form
  property :name
  property :auth_token

  validate :unique_name_for_debate?

  def error_messages
    errors.full_messages.join('. ')
  end

  private

  def unique_name_for_debate?
    errors.add(:name, 'has to be unique') if auth_token.debate
                                                       .auth_tokens
                                                       .joins(:mobile_user)
                                                       .where(MobileUser.table_name => { name: name })
                                                       .any?
  end
end
