class AddEstoqueToProduts < ActiveRecord::Migration
  def change
    add_column :produts, :entrada, :integer

    add_column :produts, :baixa, :integer

  end
end
