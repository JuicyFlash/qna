class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :files
  has_many :links
  has_many :comments
  def files
    files = []
    object.files.find_each do |file|
      files << { url: rails_blob_url(file, only_path: true) } if object.files.attached?
    end
    files
  end
end
