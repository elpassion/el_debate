class TokenRequester
  def initialize(request_headers)
    @request_headers = request_headers
  end

  def auth_token
    token = get_token_from_headers

    return unless token
    AuthToken.find_by_value token
  end

  private

  attr_reader :request_headers

  def get_token_from_headers
    return unless request_headers['Authorization'].present?
    request_headers['Authorization']
  end
end
