class AuthSerializer

  def initialize(user, debate)
    @debate = debate
    @user = user
  end

  def to_h
    {
      user_id: user.id,
      auth_token: user.auth_token.value,
      debate_closed: debate.closed?
    }
  end

  def as_json(*)
    to_h
  end

  private

  attr_reader :user, :debate
end
