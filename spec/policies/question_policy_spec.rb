require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:question) { create(:question) }
  let(:user_question) { create(:question, author: user) }

  subject { described_class }

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end
    it 'grant access if user is author' do
      expect(subject).to permit(user, user_question)
    end
  end

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end
    it 'grant access if user is author' do
      expect(subject).to permit(user, user_question)
    end
  end

  permissions :create? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end
    it 'grant access if user signed_in' do
      expect(subject).to permit(User.new, question)
    end
  end

  permissions :like? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end
    it 'grant access if user are not author the answer' do
      expect(subject).to permit(User.new, user_question)
    end
  end

  permissions :dislike? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end
    it 'grant access if user are not author the answer' do
      expect(subject).to permit(User.new, user_question)
    end
  end

  permissions :create_comment? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, question)
    end
    it 'grant access if user are logged in' do
      expect(subject).to permit(user, question)
    end
  end
end
