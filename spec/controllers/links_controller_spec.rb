require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user, best_answer: nil) }
  let!(:link) { create(:link_on_question, linkable: question) }

  describe 'DELETE #destroy' do

    it 'not delete if user is not author of @question' do
      not_author = create(:user)
      login(not_author)
      expect { delete :destroy, params: { id: link }, format: :js}.to change(Link, :count).by(0)
    end

    it 'delete link' do
      login(user)
      expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
    end
  end
end
