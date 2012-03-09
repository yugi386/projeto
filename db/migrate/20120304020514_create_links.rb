class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :texto
      t.string :arquivo_file_name
      t.boolean :ativo

      t.timestamps
    end
  end
end
