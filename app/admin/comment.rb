ActiveAdmin.register Comment do
  belongs_to :debate

  index do
    selectable_column
    id_column
    column :content
    column :status
    column :created_at
    actions
    render :partial => 'admin/store_code_debate', :locals => {:debate_code => debate[:code], :debate_id => debate[:id] }
  end

  controller do
    before_action only: :index do
      @debate = Debate.find(params[:debate_id])
    end
  end

  batch_action :activate do |ids|
    comments = Comment.find(ids).map do |comment|
      comment.active!
      CommentSerializer.new(comment).to_h
    end

    CommentNotifier.new.send_comments(params[:debate_id], comments)
    redirect_to admin_debate_comments_url, alert: "Status was changed"
  end

  batch_action :deactivate do |ids|
    Comment.find(ids).each do |comment|
      comment.inactive!
    end
    redirect_to admin_debate_comments_url, alert: "Status was changed"
  end
end
