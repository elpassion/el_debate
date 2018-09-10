require 'rails_helper'

feature 'Comment stream', :js do
  given(:admin_user) { create(:admin_user) }
  given(:debate) { create(:debate) }
  given(:user) { create(:user) }
  given!(:comment) { create(:comment, debate_id: debate.id, user: user, status: :pending) }

  background do
    login_as(admin_user)
  end

  before do
    allow_any_instance_of(PusherBroadcaster).to receive(:push).and_return(nil)
  end

  scenario 'accept comment via link' do
    visit_comment_stream_page

    click_action_link('Accept')


    within '.flash_alert' do
      expect(page).to have_content('Status was changed')
    end

    comment.reload
    expect(comment.status).to eq('accepted')
  end

  scenario 'reject comment via link' do
    visit_comment_stream_page

    click_action_link('Reject')

    within '.flash_alert' do
      expect(page).to have_content('Status was changed')
    end

    comment.reload
    expect(comment.status).to eq('rejected')
  end

  scenario 'accept comment via bath action' do
    visit_comment_stream_page

    select_comment_and_click_on_batch_action('Accept Selected')

    within '.flash_alert' do
      expect(page).to have_content('Status was changed')
    end

    comment.reload
    expect(comment.status).to eq('accepted')
  end

  scenario 'reject comment via bath action' do
    visit_comment_stream_page

    select_comment_and_click_on_batch_action('Reject Selected')

    within '.flash_alert' do
      expect(page).to have_content('Status was changed')
    end

    comment.reload
    expect(comment.status).to eq('rejected')
  end

  def click_action_link(action)
    within 'div.table_actions' do
      click_link_or_button action
    end
  end

  def visit_comment_stream_page
    visit admin_debate_commentstream_path(debate)

    expect(page).to have_content('pending')
  end

  def select_comment_and_click_on_batch_action(action)
    within 'div.resource_selection_cell' do
      page.check("batch_action_item_#{comment.id}")
    end

    within '.batch_actions_selector' do
      click_link_or_button 'Batch Actions'

      within '.dropdown_menu_list' do
        click_link_or_button action
      end
    end
  end
end
