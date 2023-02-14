
class LikesController < ApplicationController
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like(@micropost)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.turbo_stream
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(@micropost)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.turbo_stream
    end
  end

  private

end
