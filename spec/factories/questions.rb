FactoryBot.define do
  sequence :title do |t|
    "MyString_#{t}"
  end

  factory :question do
    association :author_id, factory: :user
    association :best_answer_id, factory: :answer

    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :different do
      title
      body { "MyText" }
    end
  end
end
