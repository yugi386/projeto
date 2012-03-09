class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :nome
      t.text :descricao
      t.boolean :ativo
      t.integer :destaque
      t.string :arquivo_file_name
      t.integer :departamento_id

      t.timestamps
    end
  end
end
