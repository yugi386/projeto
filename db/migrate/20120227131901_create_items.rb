class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :venda_id
      t.integer :idprod
      t.float :valor
      t.integer :quant

      t.timestamps
    end
  end
end
