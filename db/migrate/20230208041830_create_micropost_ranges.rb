class CreateMicropostRanges < ActiveRecord::Migration[7.0]
  def change
    create_table :micropost_ranges do |t|
      t.integer :range_id
      t.string :range_content

      t.timestamps
    end
  end
end
