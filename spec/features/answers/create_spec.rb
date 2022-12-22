require 'rails_helper'

feature 'User can answer to a question', '
  User can answer to a question from the question page
' do
  given(:user) { create(:user) }

  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer to a question', js: true do

      fill_in 'Body', with: 'some answer'
      click_on 'Answer'

      expect(page).to have_content 'some answer'
    end

    scenario 'answer to a question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user answer to a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
