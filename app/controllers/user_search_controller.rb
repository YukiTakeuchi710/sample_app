class UserSearchController < ApplicationController
  def search
    @users = User.where('name like ?', '%' + params[:user_name] +'%').paginate(page: params[:page])
    render 'users/index'
  end
  private
  def user_search_params
    params.require(:micropost_search).permit(:user_name)
  end
end
