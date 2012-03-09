class AddDestaqueToSecaos < ActiveRecord::Migration
  def change
    add_column :secaos, :destaque, :integer

  end
end
