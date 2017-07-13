class CommentHelpConstraint
  def self.matches?(request)
    request.params[:text].blank?
  end
end