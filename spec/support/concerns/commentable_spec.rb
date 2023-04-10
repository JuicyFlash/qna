require 'rails_helper'

RSpec.shared_examples_for 'commentable' do
  let!(:model) { described_class }
  let!(:user) { create :user }
  let!(:obj) { create(model.to_s.underscore.to_sym) }
  it { should have_many(:comments).dependent(:destroy) }

end
