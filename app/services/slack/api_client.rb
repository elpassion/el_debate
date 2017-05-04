Slack::ApiNetworkError = Class.new(StandardError)

class Slack::ApiClient
  API_TOKEN = ENV.fetch("SLACK_API_TOKEN")
  API_HOST = "https://slack.com/api".freeze
  private_constant :API_TOKEN
  private_constant :API_HOST

  def initialize(network_provider=Faraday.new)
    @network_provider = network_provider
  end

  def get_user_data(slack_id)
    response = @network_provider.get do |req|
      req.url "#{API_HOST}/users.info"
      req.params["token"] = API_TOKEN
      req.params["user"] = slack_id
    end

    raise ::Slack::ApiNetworkError, "Error fetching Slack user data" unless response.success?

    user_data = JSON.parse(response.body).fetch("user").fetch("profile")

    {
      user_image_url: user_data.fetch("image_192"),
      user_name: user_data.fetch("real_name")
    }
  end
end
