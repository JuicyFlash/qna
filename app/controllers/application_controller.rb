class ApplicationController < ActionController::Base
  before_action :current_user

  def gon_current_user
    gon.push({ current_user_id: current_user&.id })
  end
end
