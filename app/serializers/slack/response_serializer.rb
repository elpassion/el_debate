Slack::ResponseSerializer = Value.new(:text, :response_type) do
  def self.in_channel(message)
    with(
      response_type: "in_channel",
      text: message
    )
  end

  def self.not_public(message)
    with(
      response_type: "ephemeral",
      text: message
    )
  end

  def as_json(*)
    to_h.slice(:response_type, :text)
  end
end
