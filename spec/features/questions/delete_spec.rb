require 'rails_helper'

feature 'User can delete question', '
  Only the author can delete his question
' do
  given(:user) { create(:user) }

  given!(:question) do
    create(:question, author: user) do |question|
      create(:answer, question: question, author: user)
    end
  end

  describe 'Authenticated user' do
    scenario 'delete question and he is author of this question' do
      sign_in(user)
      visit questions_path
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'delete question and he isn`t author of this question' do
      not_author = create(:user)
      sign_in(not_author)
      visit questions_path
      click_on 'Delete question'

      expect(page).to have_content 'Only author can delete question.'
    end
  end

  scenario 'unauthenticated user try delete question' do
    visit questions_path
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
