require 'rails_helper'

feature 'Debates comment' do
  given(:admin_user) { create(:admin_user) }
  given(:debate) { create(:debate) }
  given(:user) { create(:mobile_user) }
  given(:comment) { create(:comment, debate_id: debate.id, user: user, status: :inactive) }

  background do
    login_as(admin_user)
  end

  before do
    FactoryGirl.create(:comment, debate_id: debate.id, user: user, status: :inactive)
  end
  scenario 'activate comment' do
    visit admin_debate_comments_path(debate)

    expect(page).to have_content('inactive')

    within 'div.batch_actions_selector' do
      click_link_or_button 'activate'
    end
    expect(page).to have_content('active')

  end
end
