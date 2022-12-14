require 'rails_helper'

feature 'User can answer to a question', '
  User can answer to a question from the question page
' do
  given!(:question) { create(:question) }

  scenario 'User answer to a question' do
    visit question_path(question)
    fill_in 'Body', with: 'some answer'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'some answer'
  end
  scenario 'User answer to a question with errors' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end
