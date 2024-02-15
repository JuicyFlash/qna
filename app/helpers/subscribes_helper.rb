# frozen_string_literal: true

module SubscribesHelper
  def data_subscrible_id(subscrible)
    "[data-#{subscrible.class.to_s.downcase}-id=#{subscrible.id}]"
  end

  def subscribe_link(resource)
    link_to 'Subscribe',
            subscribe_subscrible_path(resource),
            method: :patch,
            class: resource.have_subscription?(current_user) ? 'subscrible-link subscribe hidden' : 'subscrible-link subscribe',
            data: { type: :json },
            remote: true

  end

  def unsubscribe_link(resource)
    link_to 'Unsubscribe',
            unsubscribe_subscrible_path(resource),
            method: :patch,
            class: resource.have_subscription?(current_user) ? 'subscrible-link unsubscribe' : 'subscrible-link unsubscribe hidden',
            data: { type: :json },
            remote: true
  end

  private

  def subscribe_subscrible_path(subscrible)
    send("subscribe_#{subscrible.class.to_s.downcase}_path".to_sym, subscrible)
  end

  def unsubscribe_subscrible_path(subscrible)
    send("unsubscribe_#{subscrible.class.to_s.downcase}_path".to_sym, subscrible)
  end
end
