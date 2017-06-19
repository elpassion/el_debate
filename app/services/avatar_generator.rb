class AvatarGenerator
  URL = 'https://api.adorable.io/avatars/80/'
  FILE_FORMAT = '.png'

  def initialize(key)
    @key = key.to_s
  end

  def generate_avatar_url
    URL + @key + FILE_FORMAT
  end
end
