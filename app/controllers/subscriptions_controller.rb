class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscrible, only: %i[create]

  def create
    subscribe
  end

  def destroy
    set_subscription
    @subscrible = @subscription.subscrible
    unsubscribe
  end

  private

  def subscribe
    authorize @subscrible
    @subscrible.subscribe(current_user)
    @subscrible.save
    respond_to do |format|
      format.json { render json: respond_json_subscrible }
    end
  end

  def unsubscribe
    authorize @subscrible
    @subscrible.unsubscribe(current_user)
    respond_to do |format|
      format.json { render json: respond_json_unsubscrible }
    end
  end

  def respond_json_subscrible
    { subscrible:  @subscrible.class.to_s.downcase, id: @subscrible.id.to_s,
      have_subscription: @subscrible.have_subscription?(current_user).to_s,
      unsubscribe_path: subscription_path(@subscrible.get_subscription(current_user)) }
  end

  def respond_json_unsubscrible
    { subscrible: @subscrible.class.to_s.downcase, id: @subscrible.id.to_s,
      have_subscription: @subscrible.have_subscription?(current_user).to_s,
      subscribe_path: subscriptions_path(:params => { subscrible: { name: @subscrible.class.to_s.downcase, id: @subscrible.id } }) }
  end

  def model_subscrible_klass
    subscription_params[:name].classify.constantize
  end

  def set_subscrible
    @subscrible = model_subscrible_klass.find(subscription_params[:id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscrible).permit(:name, :id)
  end
end
