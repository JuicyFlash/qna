# frozen_string_literal: true

module Subscrible
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, dependent: :destroy, as: :subscrible
  end

  def have_subscription?(user)
    !get_subscription(user).empty?
  end

  def subscribe(user)
    subscriptions.new(subscriber: user).save unless have_subscription?(user)
  end

  def unsubscribe(user)
    get_subscription(user).delete_all if have_subscription?(user)
  end

  def get_subscription(user)
    subscriptions.where(subscriber: user)
  end
end
