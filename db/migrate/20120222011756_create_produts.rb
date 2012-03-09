class CreateProduts < ActiveRecord::Migration
  def change
    create_table :produts do |t|
      t.string :nome
      t.date :data
      t.integer :departamento_id
      t.integer :section_id
      t.string :modelo
      t.string :unidade
      t.float :custo
      t.float :prazo
      t.float :vista
      t.float :desconto
      t.float :fnorte
      t.float :fnordeste
      t.float :fsul
      t.float :fsudeste
      t.float :fcentro
      t.string :arquivo_file_name
      t.integer :destaque
      t.boolean :ativo
      t.text :descricao

      t.timestamps
    end
  end
end
