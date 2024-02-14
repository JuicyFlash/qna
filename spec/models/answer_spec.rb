# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of(:body) }
  it { should accept_nested_attributes_for :links }
  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  describe 'notify' do
    let(:question_author) { create :user }
    let(:question) { create :question, author: question_author }
    let(:answer) { build :answer, question: question }

    it 'call NotifyAuthorOfQuestionJob' do
      expect(NotifyAuthorOfQuestionJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
