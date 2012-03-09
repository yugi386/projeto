class AddTipopagToVendas < ActiveRecord::Migration
  def change
    add_column :vendas, :tipopag, :string

  end
end
