class CreateBads < ActiveRecord::Migration[7.0]
  def change
    create_table :bads do |t|
      t.integer :micropost_id
      t.integer :bad_id

      t.timestamps
    end
  end
end
