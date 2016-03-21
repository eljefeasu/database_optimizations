class AddIndexToAssemblies < ActiveRecord::Migration
  def change
    add_index :assemblies, :name
  end
end
