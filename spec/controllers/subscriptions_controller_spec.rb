require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, author: user, best_answer: nil) }

  describe 'POST #create' do
    it 'subscribe user to question' do
      login(another_user)
      expect { post :create, params: { subscrible: { name: question.class.to_s.downcase, id: question.id } }, format: :json }.to change(Subscription, :count).by(1)
    end
  end
  describe 'DELETE #destroy' do
      it 'unsubscribe user question' do
        login(user)
        expect { delete :destroy, params: { id: question.get_subscription(user) }, format: :json }.to change(Subscription, :count).by(-1)
      end
    end
end
