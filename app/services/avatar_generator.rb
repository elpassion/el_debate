class AvatarGenerator
  BASE_URL = 'https://api.adorable.io/avatars/'
  IMAGE_SIZE = '80'

  def initialize(identifier)
    @identifier = identifier.to_s
  end

  def generate_url
    BASE_URL + IMAGE_SIZE + "/#{@identifier}"
  end
end
