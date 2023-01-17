require 'rails_helper'

feature 'User can remove links to answer', '
  As an question author
  I`d like to be able to remove links
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link_on_question, linkable: answer) }


  scenario 'User remove link from answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'remove link'
      expect(page).to_not have_link link.name, href: link.url
    end
  end
  scenario 'User remove link from answer and he isn`t author of this answer', js: true do
    not_author = create(:user)
    sign_in(not_author)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'remove link'
    end
  end
end
