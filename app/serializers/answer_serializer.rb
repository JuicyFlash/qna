class AnswerSerializer < ActiveModel::Serializer
  include AttachedFiles

  attributes :id, :body, :author_id, :created_at, :updated_at, :files
  has_many :links
  has_many :comments
end
