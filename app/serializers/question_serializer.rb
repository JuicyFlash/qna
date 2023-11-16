class QuestionSerializer < ActiveModel::Serializer
  include AttachedFiles

  attributes :id, :title, :body, :created_at, :updated_at, :files
  has_many :links
  has_many :comments
end
