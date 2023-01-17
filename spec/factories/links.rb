FactoryBot.define do
  factory :link_on_question, class: Link do
    association :linkable, factory: :question

    name { "MyUrl" }
    url { "https://www.google.ru/" }
  end

  factory :link_on_answer, class: Answer do
    association :linkable, factory: :answer

    name { "MyUrl" }
    url { "https://www.google.ru/" }
  end

  trait :invalid do
    name { "MyUrl" }
    url { "MyString" }
  end
end
