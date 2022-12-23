require 'rails_helper'

feature 'User can delete answer', '
  Only the author can delete his answer
' do
  given(:user) { create(:user) }

  given!(:question) do
    create(:question, author: user) do |question|
      create(:answer, question: question, author: user)
    end
  end

  describe 'Authenticated user' do
    scenario 'delete answer and he is author of this answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'delete answer and he isn`t author of this answer' do
      not_author = create(:user)
      sign_in(not_author)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'unauthenticated user try delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
