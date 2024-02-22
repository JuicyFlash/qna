require 'sphinx_helper'

feature 'User can search for answer, question, comment or user' do
  given!(:user) { create(:user, email: 'simple@mail.ru') }
  given!(:question) { create(:question, title: 'title of first question', author: user, body: 'first question', best_answer: nil) }
  given!(:answer) { create(:answer, body: "answer for #{question.body}", question: question, author: user) }
  given!(:comment) { create(:comment_on_answer, author: user, body: "comment for #{answer.body}", commentable: answer) }

  background do
    ThinkingSphinx::Test.index
    sign_in(user)
    visit questions_path
  end

  scenario 'User search question in the all objects', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: question.body
        click_on 'Search'
      end

      expect(page).to have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
    end
  end

  scenario 'User search question in the questions', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: "question:#{question.body}"
        click_on 'Search'
      end

      expect(page).to have_content question.body

      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
    end
  end

  scenario 'User search answer in the answers', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: "answer:#{question.body}"
        click_on 'Search'
      end

      expect(page).to have_content answer.body

      expect(page).to_not have_content question.title
      expect(page).to_not have_content comment.body
    end
  end

  scenario 'User search comment in the comments', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: "comment:#{question.body}"
        click_on 'Search'
      end

      expect(page).to have_content comment.body

      expect(page).to_not have_content question.title
    end
  end

  scenario 'User search user in the users by email', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: "user:#{user.email}"
        click_on 'Search'
      end

      expect(page).to have_content user.email
    end
  end

  scenario 'User search all user`s objects', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'query', with: user.email
        click_on 'Search'
      end

      expect(page).to have_content user.email
      expect(page).to have_content answer.body
      expect(page).to have_content question.body
      expect(page).to have_content comment.body
    end
  end
end
