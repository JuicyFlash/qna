FactoryBot.define do

  sequence :body do |b|
    "MyString_#{b}"
  end

  factory :answer do
    association :question

    body { "MyString" }

    trait :invalid do
      body { nil }
    end

    trait :different do
      body
    end
  end
end
