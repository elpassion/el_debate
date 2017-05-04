class TokenRequester
  def initialize(request_headers)
    @request_headers = request_headers
  end

  def auth_token
    return unless (token = get_token_from_headers)
    AuthToken.find_by_value token
  end

  private

  attr_reader :request_headers

  def get_token_from_headers
    request_headers['Authorization'].presence
  end
end
