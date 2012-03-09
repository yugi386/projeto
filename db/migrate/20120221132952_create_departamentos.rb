class CreateDepartamentos < ActiveRecord::Migration
  def change
    create_table :departamentos do |t|
      t.string :nome
      t.text :descricao
      t.string :imagem_link
      t.boolean :ativo
      t.integer :destaque

      t.timestamps
    end
  end
end
