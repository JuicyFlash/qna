module AttachedFiles
  include Rails.application.routes.url_helpers

  def files
    files = []
    object.files.find_each do |file|
      files << { url: rails_blob_url(file, only_path: true) } if object.files.attached?
    end
    files
  end
end
