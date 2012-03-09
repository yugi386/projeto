class AddFreteToVendas < ActiveRecord::Migration
  def change
    add_column :vendas, :frete, :float

  end
end
