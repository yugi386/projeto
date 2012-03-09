class AddEstoque2ToProduts < ActiveRecord::Migration
  def change
    add_column :produts, :dataentrada, :datetime

    add_column :produts, :databaixa, :datetime

  end
end
