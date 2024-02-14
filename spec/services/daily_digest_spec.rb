require 'rails_helper'

RSpec.describe DailyDigest do
  let(:users) { create_list(:user, 3) }
  let(:questions) { create_list(:question, 3, author: users.first) }
  let!(:old_questions) { create_list(:question, 3, author: users.first, created_at: 2.days.ago) }

  it 'send daily digest to all users with all questions from 1 day ago' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original }
    subject.send_digest
  end
end
