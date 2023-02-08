class AddRangeToMicropost < ActiveRecord::Migration[7.0]
  def change
    add_column :Microposts, :range, :integer, null:false, default:0
  end
end
