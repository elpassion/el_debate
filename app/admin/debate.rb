ActiveAdmin.register Debate do
  permit_params :topic, answers_attributes: [:id, :value]

  index do
    selectable_column
    id_column
    column :topic
    column :code
    column :created_at
    column :closed_at
    actions do |debate|
      if debate.closed?
        link_to('Reopen', reopen_admin_debate_path(debate), method: :put)
      else
        link_to('Close', close_admin_debate_path(debate), method: :put)
      end
    end
  end

  show title: proc { |debate| debate.topic } do
    attributes_table do
      row :topic
      row :code
      row :closed_at
      row :answers do |debate|
        debate.answers.map do |answer|
          link_to answer.value, admin_debate_answer_path(debate, answer.id)
        end.join(', ').html_safe
      end
      row 'All votes', &:votes_count

      debate.answers.each do |answer|
        row %(Votes for "#{answer.value}") do
          answer.votes_count
        end
      end
    end
  end

  member_action :close, method: :put do
    Debates::CloseService.new(debate: resource).call
    redirect_to resource_path, notice: 'Debate closed!'
  end

  member_action :reopen, method: :put do
    Debates::ReopenService.new(debate: resource).call
    redirect_to resource_path, notice: 'Debate reopened!'
  end

  action_item :close_or_reopen, only: :show do
    if resource.closed?
      link_to('Reopen', reopen_admin_debate_path(debate), method: :put)
    else
      link_to('Close', close_admin_debate_path(debate), method: :put)
    end
  end

  form title: 'New Debate' do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.input :topic
    f.has_many :answers, new_record: false do |b|
      b.input :value
      b.input :answer_type, :input_html => { :disabled => true }
    end
    f.actions
  end
end
