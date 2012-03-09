class AddCampoparcelasToProduts < ActiveRecord::Migration
  def change
    add_column :produts, :parcelas, :integer

  end
end
