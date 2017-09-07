require 'rails_helper'

feature 'Viewing Dashboard' do
  context 'when debate already has comments', :js do
    let(:debate) { create(:debate, moderate: false) }
    let(:user) { create(:user, auth_token: debate.create_auth_token!) }

    before do
      20.times do
        create(:comment, user: user, debate: debate, status: :accepted)
      end
    end

    scenario 'At most 5 comments are shown' do
      visit dashboard_path(slug: debate.slug)

      within 'div.comments' do
        expect(page).to have_selector('.comment', maximum: 5, minimum: 1)
      end
    end
  end
end
