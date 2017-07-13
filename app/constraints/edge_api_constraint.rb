class EdgeApiConstraint
  def self.matches?(request)
    request.headers.fetch(:accept).include?('edge=1')
  end
end