require 'rails_helper'

RSpec.describe Notify do
  let(:user) { create(:user) }
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }

  it 'send notify to question subscribers' do
    users.each { |user| question.subscribe(user) }

    users.each { |user| expect(QuestionSubscribersMailer).to receive(:notify).with(user).and_call_original }

    expect(QuestionSubscribersMailer).to receive(:notify).with(question.author).and_call_original
    subject.notify_question_subscribers(question)
  end
end
