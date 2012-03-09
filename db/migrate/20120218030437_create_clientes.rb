class CreateClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      t.string :nome
      t.date :data_nasc
      t.string :sexo
      t.string :cpf
      t.string :rg
      t.string :endereco
      t.string :cidade
      t.string :estado
      t.string :cep
      t.string :tel
      t.string :cel
      t.string :email
      t.text :obs

      t.timestamps
    end
  end
  
  def self.down
	drop.table :clientes
  end
  
end
