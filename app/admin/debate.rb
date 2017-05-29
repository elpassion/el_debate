ActiveAdmin.register Debate do
  permit_params :topic, :closed_at, :channel_name, answers_attributes: [:id, :value]

  index do
    selectable_column
    id_column
    column :topic
    column :code
    column :created_at
    column :closed_at
    column :channel_name
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
      row :link do |debate|
        link_to "Go to dashboard", "/dashboard/#{debate.slug}"
      end

      row :code do |debate|
        debate.code.presence || link_to('Generate code', code_admin_debate_path, method: :post)
      end
      row :closed_at
      row :channel_name
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

  member_action :code, method: :post do
    resource.update!(code: CodeGenerator.new.generate)
    opts = resource.code? ? { notice: 'Code generated' } : { alert: 'Could not generate code' }
    redirect_to resource_path, opts
  end

  after_update do |debate|
    DebateNotifier.build.notify(debate)
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

    f.inputs do
      f.input :topic
      f.input :channel_name
      f.input :closed_at, as: :datetime_picker, local: true
    end

    unless f.object.new_record?
      f.inputs do
        f.has_many :answers, new_record: false do |b|
          b.input :value
          b.input :answer_type, :input_html => { :disabled => true }
        end
      end
    end

    f.actions
  end

  controller do
    def create
      new_debate = DebateMaker.call(
        permitted_params.require(:debate)
      )

      redirect_to admin_debate_path(new_debate)
    end
  end
end
