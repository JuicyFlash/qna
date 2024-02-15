class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def update?
    admin_or_author
  end

  def destroy?
    admin_or_author
  end

  def create?
    user.present?
  end

  def subscribe?
    return false unless user.present?

    true
  end

  def unsubscribe?
    return false unless user.present?

    true
  end

  def like?
    return false unless user.present?

    user.admin? || record.author != user
  end

  def dislike?
    return false unless user.present?

    like?
  end

  def create_comment?
    create?
  end
end
