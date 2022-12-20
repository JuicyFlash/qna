require 'rails_helper'

feature 'User can view question',
        'User can view question, and answers for this question
' do
  given(:user) { create(:user) }

  given!(:question) do
    create(:question, author: user) do |question|
      create_list(:answer, 3, :different, question: question, author: user)
    end
  end
  scenario 'view question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
  scenario 'view list of questions`s answers' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content question.answers[0].body
      expect(page).to have_content question.answers[1].body
      expect(page).to have_content question.answers[2].body
    end
  end
end
