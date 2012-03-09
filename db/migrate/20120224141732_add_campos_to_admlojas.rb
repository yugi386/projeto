class AddCamposToAdmlojas < ActiveRecord::Migration
  def change
    add_column :admlojas, :rodape, :text

    add_column :admlojas, :cabecalho, :text

  end
end
