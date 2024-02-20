# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscrible

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, class_name: 'Reward', dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :subscribe_author

  def reward_best_answer
    return if reward.nil?

    reward.user_id = if best_answer.nil?
                       nil
                     else
                       best_answer.author.id
    end
  end

  private

  def subscribe_author
    subscribe(author)
  end
end
