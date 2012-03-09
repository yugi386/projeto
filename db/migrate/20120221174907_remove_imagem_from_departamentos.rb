class RemoveImagemFromDepartamentos < ActiveRecord::Migration
  def up
    remove_column :departamentos, :imagem_link
      end

  def down
    add_column :departamentos, :imagem_link, :string
  end
end
