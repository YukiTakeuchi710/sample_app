class BadsController < ApplicationController
  before_action :logged_in_user
  def create
    @micropost = Micropost.find(params[:micropost_id])
    unless @micropost.bad?(current_user)
      @micropost.bad(current_user)
      respond_to do |format|
        format.html{ redirect_to microposts_path(@micropost)}
        format.turbo_stream
      end
    end
  end

  def destroy
    @micropost = Bad.find(params[:id]).micropost
    if @micropost.bad?(current_user)
      @micropost.unbad(current_user)
      respond_to do |format|
        format.html{ redirect_to microposts_path(@micropost)}
        format.turbo_stream
      end
    end
  end
end
