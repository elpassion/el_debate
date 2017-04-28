Slack::ResponseSerializer = Value.new(:text, :response_type) do
  def to_json
    {
      response_type: response_type,
      text: text
    }
  end
end
