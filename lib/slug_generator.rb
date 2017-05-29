class SlugGenerator
  def initialize(attribute, code_generator)
    @attribute = attribute
    @code_generator = code_generator
  end

  def call(object)
    raw = object.public_send(attribute)
    base = raw.downcase.gsub(/[^0-9a-z ]/i, '').split(' ').first(6).join('-')
    "#{base}-#{code_generator.generate}"
  end

  private

  attr_reader :attribute, :code_generator
end
