class MutesController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:muted_id])
    current_user.mute(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  def destroy
    @user = Mute.find(params[:id]).muted
    current_user.unmute(@user)
    respond_to do |format|
      format.html { redirect_to @user, status: :see_other }
      format.turbo_stream
    end
  end
end