class RemoveDesta2FromSecaos < ActiveRecord::Migration
  def up
    remove_column :secaos, :destaque
      end

  def down
    add_column :secaos, :destaque, :string
  end
end
