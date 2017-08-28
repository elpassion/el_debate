require 'rails_helper'

feature 'Debates comment' do
  given(:admin_user) { create(:admin_user) }
  given(:debate) { create(:debate) }
  given(:user) { create(:mobile_user) }
  given(:comment) { create(:comment, debate_id: debate.id, user: user, status: :pending) }

  background do
    login_as(admin_user)
  end

  before do
    FactoryGirl.create(:comment, debate_id: debate.id, user: user, status: :pending)
  end
  scenario 'activate comment' do
    visit admin_debate_comments_path(debate)

    expect(page).to have_content('pending')

    within 'div.table_actions' do
      click_link_or_button 'accept'
    end
    expect(page).to have_content('accepted')

  end
end
