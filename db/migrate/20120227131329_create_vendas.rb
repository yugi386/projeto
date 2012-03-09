class CreateVendas < ActiveRecord::Migration
  def change
    create_table :vendas do |t|
      t.date :data
      t.integer :cliente
      t.float :valor
      t.integer :itens
      t.string :status

      t.timestamps
    end
  end
end
