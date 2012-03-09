class AddNomeToVendas < ActiveRecord::Migration
  def change
    add_column :vendas, :cliente_nome, :string

  end
end
