class CreateModel < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.integer :age
      t.hstore :dynamic_attributes
      t.index :dynamic_attributes
    end
  end
end
