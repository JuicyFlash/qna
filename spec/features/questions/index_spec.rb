require 'rails_helper'

feature 'User can view list of questions' do
  given!(:questions) { create_list(:question, 3, :different) }

  scenario 'view list of questions' do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end
end
