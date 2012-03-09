class RemoveCamposFromAdmlojas < ActiveRecord::Migration
  def up
    remove_column :admlojas, :rodape
        remove_column :admlojas, :cabecalho
      end

  def down
    add_column :admlojas, :cabecalho, :string
    add_column :admlojas, :rodape, :string
  end
end
