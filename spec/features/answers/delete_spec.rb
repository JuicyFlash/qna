require 'rails_helper'

feature 'User can delete answer', '
  Only the author can delete his answer
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }


  describe 'Authenticated user' do
    scenario 'delete answer and he is author of this answer', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Delete answer'
        expect(page).to_not have_content answer.body
      end
    end

    scenario 'delete answer and he isn`t author of this answer', js: true do
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
