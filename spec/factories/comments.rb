FactoryBot.define do
  factory :comment_on_question, class: Comment do
    association :commentable, factory: :question
    body { "MyTestComment" }
  end

  factory :comment_on_answer, class: Comment do
    association :commentable, factory: :answer
    body { "MyTestComment" }
  end
end
