class RenameLikeIdColumnToLikes2 < ActiveRecord::Migration[7.0]
  def change
    rename_column :likes, :like_id, :user_id
  end
end
