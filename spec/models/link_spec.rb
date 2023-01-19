require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user, best_answer: nil) }
  let(:link) { build(:link_on_question, linkable: question) }
  let(:invalid_link) { build(:link_on_question, :invalid, linkable: question) }
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it 'have valid url' do
    object = link
    expect(object).to be_valid
  end
  it 'have invalid link' do
    object = invalid_link
    expect(object).to_not be_valid
  end
end
