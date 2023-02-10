class MicropostSearchController < ApplicationController

  def search
    @micropost  = current_user.microposts.build
    @feed_items = current_user.search_microposts(params).paginate(page: params[:page])
    render 'static_pages/home'
  end
  private
    def micropost_search_params
      params.require(:micropost_search).permit(:search_type, :search_content)
    end

end
