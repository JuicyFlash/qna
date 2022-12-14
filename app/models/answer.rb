# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
  #, { message: 'level and title must be uniq' }
end
