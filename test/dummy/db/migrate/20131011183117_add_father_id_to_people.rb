class AddFatherIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :father_id, :integer
  end
end
