class AnswerPolicy < ApplicationPolicy
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

  def best?
    return false unless user.present?

    user.admin? || record.question.author == user
  end

  def like?
    return false unless user.present?

    user.admin? || record.author != user
  end

  def dislike?
    return false unless user.present?

    user.admin? || record.author != user
  end

  def create_comment?
    create?
  end
end
