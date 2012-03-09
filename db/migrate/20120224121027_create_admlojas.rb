class CreateAdmlojas < ActiveRecord::Migration
  def change
    create_table :admlojas do |t|
	  t.string :nome
      t.string :cnpj
      t.string :endereco
      t.string :cidade
	  t.string :bairro
      t.string :estado
	  t.string :complemento
	  t.string :cpostal
      t.string :cep
      t.string :tel
	  t.string :fax
      t.string :cel
      t.string :email
	  t.string :password
	  # CAMPOS ABAIXO SÃO DE CONFIGURACOES:
	  t.integer :pagadm		# paginacao da area administrativa
	  t.integer :pagloja	# paginacao da area loja
	  
	  t.string :rodape		# rodape da pagina
	  t.string :cabecalho   # cabecalho
	  t.integer :mcab	    # mostrar cabecalho em todas as paginas (0), somente na principal (1). 
	  
	  t.integer :maxdep  	# maximo de departamentos a exibir no menu principal
	  t.integer :maxsec  	# maximo de secoes a exibir no menu principal
	  
	  t.integer :upreco  	# utilizar preco a vista ao mostrar produtos (1), a prazo (2), nao mostrar preco (0) 
	  
	  t.integer :udesconto 	# utilizar desconto para preco a vista(1), desconto para preco a prazo (2), ignorar desconto (0) 
	  
	  t.integer :ufrete 	# considerar frete (1), ignorar frete (0)
	  t.integer :freefrete 	# frete gratis a partir de valor X.
	  

      t.text :obs
      t.timestamps
    end
  end
end
