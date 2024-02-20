require 'rails_helper'

RSpec.shared_examples_for 'subscrible' do
  let!(:model) { described_class }
  let!(:user) { create :user }
  let!(:obj) { create(model.to_s.underscore.to_sym) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it 'can subscribe' do
    expect(obj.subscriptions.count).to eq 1
    obj.subscribe(user)
    expect(obj.subscriptions.count).to eq 2
  end

  it 'can unsubscribe' do
    obj.subscribe(user)
    expect(obj.subscriptions.count).to eq 2
    obj.unsubscribe(user)
    expect(obj.subscriptions.count).to eq 1
  end

  it 'not subscribe if already subscribed ' do
    obj.subscribe(user)
    expect(obj.subscriptions.count).to eq 2
    obj.subscribe(user)
    expect(obj.subscriptions.count).to eq 2
  end
end
