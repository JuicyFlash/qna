require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:answer) { create(:answer) }
  let(:user_answer) { create(:answer, author: user) }

  subject { described_class }

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user is author' do
      expect(subject).to permit(user, user_answer)
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user is author' do
      expect(subject).to permit(user, user_answer)
    end
  end

  permissions :create? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user signed_in' do
      expect(subject).to permit(User.new, answer)
    end
  end

  permissions :best? do
    let(:question) { create(:question, author: user) }

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user author the question' do
      expect(subject).to permit(user, create(:answer, question: question))
    end
  end

  permissions :like? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user are not author the answer' do
      expect(subject).to permit(User.new, user_answer)
    end
  end

  permissions :dislike? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user are not author the answer' do
      expect(subject).to permit(User.new, user_answer)
    end
  end

  permissions :create_comment? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end
    it 'grant access if user are logged in' do
      expect(subject).to permit(user, answer)
    end
  end
end
