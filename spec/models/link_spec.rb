require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user, best_answer: nil) }

  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it 'have valid url' do
    object = FactoryBot.build(:link, linkable: question)
    expect(object).to be_valid
  end
  it 'have invalid link' do
    object = FactoryBot.build(:link, :invalid, linkable: question)
    expect(object).to_not be_valid
  end
end
