require 'rails_helper'

feature 'Reopening debate' do
  given(:admin_user) { create(:admin_user) }
  given(:debate) { create(:debate, closed_at: Time.now) }

  background do
    login_as(admin_user)
  end

  scenario 'Reopening debate in admin panel' do
    visit admin_debate_path(debate)
    within 'div.title_bar' do
      click_link_or_button 'Reopen'
    end

    expect(page).to have_selector('div.flash_notice')
    expect(page).to have_content('Debate reopened!')

    visit "/dashboard/#{debate.id}"
    within 'p#debate-status' do
      expect(page).not_to have_content('closed')
    end
  end
end
