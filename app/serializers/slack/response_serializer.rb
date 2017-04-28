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

  def to_json(*)
    to_h
  end
end
