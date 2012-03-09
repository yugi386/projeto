class AddUpdateToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :pessoa, :string

    add_column :clientes, :cnpj, :string

    add_column :clientes, :complemento, :string

    add_column :clientes, :cpostal, :string

    add_column :clientes, :endereco2, :string

    add_column :clientes, :cidade2, :string

    add_column :clientes, :estado2, :string

    add_column :clientes, :cep2, :string

    add_column :clientes, :telefone2, :string

    add_column :clientes, :celular2, :string

    add_column :clientes, :complemento2, :string

    add_column :clientes, :cpostal2, :string

    add_column :clientes, :password, :string

  end
end
