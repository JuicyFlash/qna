require 'rails_helper'

feature 'User can add links to question', '
  In order to provide additional info to my question
  As an question author
  I`d like to be able to add links
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user, best_answer: nil) }
  given(:gist_url) { 'https://gist.github.com/JuicyFlash/33c85a488910031155b2da32ed3af130' }
  given(:ya_url) { 'https://www.ya.ru/' }
  given(:google_url) { 'https://www.google.ru/' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'some text some tex some tex'
    fill_in 'Link name', with: 'My Ya'
    fill_in 'Url', with: ya_url
    click_on 'Ask'

    expect(page).to have_link 'My Ya', href: ya_url
  end

  scenario 'User adds several links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'some text some tex some tex'
    fill_in 'Link name', with: 'My Ya'
    fill_in 'Url', with: ya_url
    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My google'
      fill_in 'Url', with: google_url
    end
    click_on 'Ask'

    expect(page).to have_link 'My Ya', href: ya_url
    expect(page).to have_link 'My google', href: google_url
  end

  scenario 'User add invalid link', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'some text some tex some tex'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'My gist_url'
    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end

  scenario 'User add link while edit question', js: true do
    sign_in(user)
    visit edit_question_path(question)
    click_on 'add link'
    fill_in 'Link name', with: 'My google'
    fill_in 'Url', with: google_url
    click_on 'Save'

    within '.question-details' do
      expect(page).to have_link 'My google', href: google_url
    end
  end
end