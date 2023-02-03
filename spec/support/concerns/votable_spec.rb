require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let!(:model) { described_class }
  let!(:user) { create :user }
  let!(:obj) { create(model.to_s.underscore.to_sym) }
  it { should have_many(:votes).dependent(:destroy) }

  it 'can vote' do
    expect(obj.votes.count).to eq 0
    obj.set_vote(user, 1)
    expect(obj.votes.count).to eq 1
  end

  it 'can`t vote if author' do
    obj = create(model.to_s.underscore.to_sym, author: user)
    expect(obj.votes.count).to eq 0
    obj.set_vote(user, 1)
    expect(obj.votes.count).to eq 0
  end

  it 'can unvote' do
    obj.set_vote(user, 1)
    expect(obj.votes.count).to eq 1
    obj.set_vote(user, 1)
    expect(obj.votes.count).to eq 0
  end

  it 'can get votes value' do
    second_user = create :user
    obj.set_vote(user, -1)
    obj.set_vote(second_user, -1)
    expect(obj.votes_value).to eq(-2)
  end
  it 'can get have_votes? 'do
    expect(obj.votes.count).to eq 0
    expect(obj.have_vote?(user)).to eq false
    obj.set_vote(user, 1)
    expect(obj.votes.count).to eq 1
    expect(obj.have_vote?(user)).to eq true
  end
end
