class CreateSearchTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :search_types do |t|
      t.integer :search_type_id
      t.string :search_type_content

      t.timestamps
    end
  end
end
