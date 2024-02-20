class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User', foreign_key: :subscriber_id
  belongs_to :subscrible, polymorphic: true
end
