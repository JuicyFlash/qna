class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :val, presence: true
end
