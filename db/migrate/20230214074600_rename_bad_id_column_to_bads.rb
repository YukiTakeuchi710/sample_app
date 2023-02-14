class RenameBadIdColumnToBads < ActiveRecord::Migration[7.0]
  def change
    rename_column :bads, :bad_id, :user_id
  end
end
