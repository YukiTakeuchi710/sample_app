
class LikesController < ApplicationController
  before_action :logged_in_user
  def index
    @microposts = Like.find_by(micropost_id: params[:id])
  end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    unless @micropost.liked?(current_user)
      @micropost.like(current_user)
    end
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    if @micropost.liked?(current_user)
      @micropost.unlike(current_user)
    end
  end

end
