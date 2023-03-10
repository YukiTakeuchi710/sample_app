
class LikesController < ApplicationController
  before_action :logged_in_user
  def create
    @micropost = Micropost.find(params[:micropost_id])
    unless @micropost.liked?(current_user)
      if @micropost.like(current_user)
        respond_to do |format|
          format.html{ redirect_to microposts_path(@micropost)}
          format.turbo_stream
        end
      else

      end
    end
  end

  def destroy
    @micropost = Like.find(params[:id]).micropost
    if @micropost.liked?(current_user)
      @micropost.unlike(current_user)
      respond_to do |format|
        format.html{ redirect_to microposts_path(@micropost)}
        format.turbo_stream
      end
    end
  end

end
