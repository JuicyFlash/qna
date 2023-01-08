require 'rails_helper'

feature 'User can edit his answer', '
  In order to correct mistakes
  As an author of answer
  I`d like to be able to edit my answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user`s answer", js: true do
      not_author = create(:user)
      sign_in(not_author)
      visit question_path(question)
      within '.answers' do

        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
