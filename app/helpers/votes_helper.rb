# frozen_string_literal: true

module VotesHelper

  def data_votable_id(votable)
    "[data-#{votable.class.to_s.downcase}-id=#{votable.id}]"
  end

  def like_link(resource)
    link_to resource.have_vote?(current_user) ? 'Unvote' : 'Like', like_votable_path(resource), method: :patch,
                                                                                                class: 'vote-link like', data: { type: :json }, remote: true
  end

  def dislike_link(resource)
    if resource.have_vote?(current_user)
      return link_to 'Dislike', dislike_votable_path(resource), method: :patch, class: 'vote-link dislike hidden',
                                                                data: { type: :json }, remote: true
    end

    link_to 'Dislike', dislike_votable_path(resource), method: :patch, class: 'vote-link dislike', remote: true
  end

  private

  def like_votable_path(votable)
    send("like_#{votable.class.to_s.downcase}_path".to_sym, votable)
  end

  def dislike_votable_path(votable)
    send("dislike_#{votable.class.to_s.downcase}_path".to_sym, votable)
  end
end
