class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @microposts = current_user.feed(current_user.id).paginate(page: params[:page])
    end
  end
  def search
  end
  def help
  end

  def about
  end
  def contact
  end

end
