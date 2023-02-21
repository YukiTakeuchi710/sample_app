class MicropostSearchController < ApplicationController

  def index
    @micropost  = current_user.microposts.build
    @microposts = current_user.search_microposts(current_user.id, params).paginate(page: params[:page])
    respond_to do |format|
      # turbo_frame variantで分岐
      format.html.turbo_stream { redirect_to @microposts }
    end
  end
  private
    def micropost_search_params
      params.require(:micropost_search).permit(:search_type, :search_content)
    end

end
