require 'rails_helper'

RSpec.describe Notify do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }

  it 'send notify to author of question' do
    expect(AuthorOfQuestionMailer).to receive(:notify).with(question.author, answer).and_call_original
    subject.notify_author_of_question(answer)
  end
end
