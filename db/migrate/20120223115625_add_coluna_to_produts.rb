class AddColunaToProduts < ActiveRecord::Migration
  def change
    add_column :produts, :preco_oculto, :boolean

    add_column :produts, :verif, :boolean

  end
end
