class RemoveDestaFromSecaos < ActiveRecord::Migration
  def up
    remove_column :secaos, :destaque
      end

  def down
    add_column :secaos, :destaque, :string
  end
end
