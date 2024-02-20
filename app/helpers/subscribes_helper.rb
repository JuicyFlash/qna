# frozen_string_literal: true

module SubscribesHelper
  def data_subscrible_id(subscrible)
    "[data-#{subscrible.class.to_s.downcase}-id=#{subscrible.id}]"
  end

  def subscrible_link(resource)
    if resource.have_subscription?(current_user)
      link_to 'Unsubscribe',
              subscription_path(resource.get_subscription(current_user)),
              method: :DELETE,
              class: 'subscrible-link unsubscribe',
              data: { type: :json },
              remote: true

    else
      link_to 'Subscribe',
              subscriptions_path(:params => {subscrible: { name: resource.class.to_s.downcase, id: resource.id } }),
              method: :post,
              class: 'subscrible-link subscribe',
              data: { type: :json },
              remote: true
    end
  end

  private

  def subscribe_subscrible_path(subscrible)
    send("subscribe_#{subscrible.class.to_s.downcase}_path".to_sym, subscrible)
  end

  def unsubscribe_subscrible_path(subscrible)
    send("unsubscribe_#{subscrible.class.to_s.downcase}_path".to_sym, subscrible)
  end
end
