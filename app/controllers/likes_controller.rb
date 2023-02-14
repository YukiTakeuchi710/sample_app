
class LikesController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @micropost = Micropost.find(params[:muted_id])
    current_user.mute(@user)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.turbo_stream
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @micropost = Micropost.find(params[:muted_id])
    current_user.unmute(@user)
    respond_to do |format|
      format.html { redirect_to @user, status: :see_other }
      format.turbo_stream
    end
  end

  private

end
