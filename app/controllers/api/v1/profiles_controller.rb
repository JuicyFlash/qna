class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    render json: current_resource_owner
  end

  def all
    @users ||= User.select { |user| user.id != current_resource_owner.id }
    render json: @users, root: 'users'
  end
end
