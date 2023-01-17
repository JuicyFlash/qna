class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if @link.linkable.author.id == current_user.id
  end
end
