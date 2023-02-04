# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_votable, only: %i[like dislike]
  end

  def like
    @votable.set_vote(current_user, 1)
    @votable.save
    respond_to do |format|
      format.json { render json: respond_json }
    end
  end

  def dislike
    @votable.set_vote(current_user, -1)
    @votable.save
    respond_to do |format|
      format.json { render json: respond_json }
    end
  end

  private

  def respond_json
    { votable: model_klass.to_s.downcase.to_s, id: @votable.id.to_s,
      value: @votable.votes_value.to_s, have_votes: @votable.have_vote?(current_user).to_s }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
