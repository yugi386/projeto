class AddCampoToVendas < ActiveRecord::Migration
  def change
    add_column :vendas, :parcelas, :integer

    add_column :vendas, :dadoscartao, :string

  end
end
