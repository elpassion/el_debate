class DebateMaker
  CODE_GENERATION_MAX_RETRIES = 5
  private_constant :CODE_GENERATION_MAX_RETRIES

  def initialize(code_generator, slug_generator)
    @code_generator = code_generator
    @slug_generator = slug_generator
  end

  def self.call(params)
    code_generator = ::CodeGenerator.for(Debate)

    new(
      code_generator,
      ::SlugGenerator.new(:topic, code_generator)
    ).call(params)
  end

  def call(params)
    debate = Debate.new(params)
    generate_slug(debate)
    generate_code(debate)
    debate.save

    add_default_answers(debate)

    debate
  end

  private

  def generate_code(debate)
    code_generator.generate(num_retries: CODE_GENERATION_MAX_RETRIES) do |code|
      next if Debate.find_by(code: code)
      debate.code = code
    end
  rescue code_generator.num_retries_error
    # noop
  end

  def generate_slug(debate)
    debate.slug = slug_generator.call(debate)
  end

  def add_default_answers(debate)
    debate.answers << Answer.default_answers
  end

  attr_reader :slug_generator, :code_generator
end
