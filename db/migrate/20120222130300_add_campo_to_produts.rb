class AddCampoToProduts < ActiveRecord::Migration
  def change
    add_column :produts, :codigo, :string

    add_column :produts, :quant, :integer

  end
end
