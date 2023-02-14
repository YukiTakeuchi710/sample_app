class BadsController < ApplicationController
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.bad(@micropost.id)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.turbo_stream
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.unbad(@micropost.id)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.turbo_stream
    end
  end
end
