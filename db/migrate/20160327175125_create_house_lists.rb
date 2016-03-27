class CreateHouseLists < ActiveRecord::Migration
  def change
    create_table :house_lists, :id => false do |t|
      t.integer :list_id
      t.integer :house_id

      t.timestamps
    end
  end
end
