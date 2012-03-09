class AddEstoque3ToProduts < ActiveRecord::Migration
  def change
    add_column :produts, :saida, :integer

    add_column :produts, :datasaida, :datetime

  end
end
