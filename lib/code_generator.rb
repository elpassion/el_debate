class CodeGenerator
  CODE_LENGTH = 5
  CODE_CHARSET = ('0'..'9')

  private_constant :CODE_LENGTH
  private_constant :CODE_CHARSET

  NumRetriesExceeded = Class.new(StandardError)

  def self.for(klass)
    new(
      klass::CODE_LENGTH,
      klass::CODE_CHARSET
    )
  end

  def initialize(length = CODE_LENGTH, charset = CODE_CHARSET)
    @length  = length
    @charset = Array(charset)
  end

  def generate(num_retries: 1)
    if block_given?
      codes(num_retries).find(-> { retries_exceeded!(num_retries) }) do |code|
        yield(code)
      end
    else
      codes(1).first
    end
  end

  def num_retries_error
    NumRetriesExceeded
  end

  private

  attr_reader :charset, :length

  def random_code
    Array.new(length) { charset.sample }.join
  end

  def codes(num)
    1.upto(num)
     .lazy
     .map { random_code }
  end

  def retries_exceeded!(num)
    raise num_retries_error, "tried #{num} times with no luck"
  end
end
