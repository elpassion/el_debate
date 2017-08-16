ActiveAdmin.register Comment do
  belongs_to :debate
  actions :all, :except => [:show, :edit]

  index do
    selectable_column
    id_column
    column :content
    column :status
    column :created_at
    actions do |comment|
      if comment.active?
        link_to "deactivate", deactivate_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link'
      elsif comment.inactive?
        link_to "activate", activate_admin_debate_comment_path(debate, comment), method: :put, class: 'member_link'
      end

    end
    render :partial => 'admin/store_code_debate', :locals => { :debate_code => debate[:code], :debate_id => debate[:id] }
  end

  member_action :activate, method: :put do
    debate = Debate.find(params[:debate_id])
    resource.active!
    CommentNotifier.new.call(resource, "dashboard_channel_#{debate[:code]}")
    redirect_to admin_debate_comments_url, alert: "Status was changed"
  end

  member_action :deactivate, method: :put do
    debate = Debate.find(params[:debate_id])
    resource.inactive!
    redirect_to admin_debate_comments_url, alert: "Status was changed"
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
