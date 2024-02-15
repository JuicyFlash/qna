# frozen_string_literal: true

module Subscribed
  extend ActiveSupport::Concern
  included do
    before_action :set_subscrible, only: %i[subscribe unsubscribe]
  end

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
    @subscrible.save
    respond_to do |format|
      format.json { render json: respond_json_subscrible }
    end
  end

  private

  def respond_json_subscrible
    { subscrible: model_klass.to_s.downcase.to_s, id: @subscrible.id.to_s,
      have_subscription: @subscrible.have_subscription?(current_user).to_s }
  end

  def model_subscrible_klass
    controller_name.classify.constantize
  end

  def set_subscrible
    @subscrible = model_subscrible_klass.find(params[:id])
  end
end
