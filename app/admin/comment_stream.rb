ActiveAdmin.register_page 'CommentStream' do
  belongs_to :debate

  content do
    debate = Debate.find_by_id!(params[:debate_id])
    comments = debate.comments.where(status: :pending).order(id: :desc)
    render partial: 'admin/comment_stream', locals: { comments: comments, debate: debate }
  end
end
