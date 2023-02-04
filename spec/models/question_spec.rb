# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }
  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  describe 'reward best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user, best_answer: nil) }
    let!(:answer) { create(:answer, author: user, question: question) }
    let!(:reward) { create(:reward, question: question) }

    it 'set reference from question`s reward to the best answer`s author' do
      question.best_answer = answer

      expect(user.rewards.first).to eq nil

      question.reward_best_answer
      question.save

      expect(user.rewards.first).to eq reward
    end
    it 'change rewarded user, after change best answer' do
      other_user = create(:user)
      other_answer = create(:answer, author: other_user, question: question)
      question.best_answer = answer
      question.reward_best_answer
      question.save

      expect(user.rewards.first).to eq reward

      question.best_answer = other_answer
      question.reward_best_answer
      question.save

      expect(user.rewards.first).to eq nil
      expect(other_user.rewards.first).to eq reward
    end
    it 'remove reference from question`s reward to the answer`s author, if attribute best was removed' do
      question.best_answer = answer
      question.reward_best_answer
      question.save

      expect(user.rewards.first).to eq reward

      question.best_answer_id = nil
      question.reward_best_answer
      question.save

      expect(user.rewards.first).to eq nil
    end
  end
end
