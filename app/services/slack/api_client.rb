Slack::ApiNetworkError = Class.new(StandardError)

class Slack::ApiClient
  API_TOKEN = ENV.fetch("SLACK_API_TOKEN")
  API_HOST = "https://slack.com".freeze
  private_constant :API_TOKEN
  private_constant :API_HOST

  def self.build
    new(Faraday.new(API_HOST))
  end

  def initialize(network_provider)
    @network_provider = network_provider
  end

  def get_user_data(slack_id)
    response = @network_provider.get(
      "/api/users.info",
       { user: slack_id }.reverse_merge(default_params)
    )

    raise ::Slack::ApiNetworkError, "Error fetching Slack user data" unless response.success?

    user_data = JSON.parse(response.body).fetch("user").fetch("profile")

    {
      user_image_url: user_data.fetch("image_192"),
      user_name: user_data.fetch("real_name")
    }
  end

  private

  def default_params
    { token: API_TOKEN }
  end
end
