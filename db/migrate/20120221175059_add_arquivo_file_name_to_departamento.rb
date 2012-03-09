class AddArquivoFileNameToDepartamento < ActiveRecord::Migration
  def change
    add_column :departamentos, :arquivo_file_name, :string

  end
end
