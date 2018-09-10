class ARStream
  DIRECTIONS = %i[backward forward].freeze

  class << self
    def build(direction, relation, start_at: nil)
      bad_direction!(direction) unless DIRECTIONS.include?(direction)
      klass = const_get(direction.to_s.camelize)
      klass.new(relation, start_at: start_at)
    end

    def bad_direction!(direction)
      raise ArgumentError,
            "unknown direction `#{direction}`, available directions are #{DIRECTIONS.inspect}"
    end
  end

  attr_reader :position

  def initialize(relation, start_at: nil)
    @relation = relation
    @position = start_at
  end

  def next(records_count)
    records = query.limit(records_count).to_a
    update_position!(records) unless records.empty?
    records
  end

  private

  attr_reader :relation
  attr_writer :position

  def query
    raise NotImplementedError
  end

  def update_position!(_records)
    raise NotImplementedError
  end
end
