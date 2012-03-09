class AddBairroToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :bairro1, :string

    add_column :clientes, :bairro2, :string

  end
end
