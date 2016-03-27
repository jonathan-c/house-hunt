class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.integer :number
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :price
      t.integer :list_id

      t.timestamps
    end
  end
end
