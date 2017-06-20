class AvatarGenerator
  BASE_URL = 'https://api.adorable.io/avatars'
  IMAGE_SIZE = 80

  def initialize(identifier)
    @identifier = identifier
  end

  def generate_url
    "#{BASE_URL}/#{IMAGE_SIZE}/#{@identifier}"
  end
end
