class ComprasController < ApplicationController
	layout "loja"	# Definindo layout da loja
	
	# Mostra o Carrinho de Compras
	def index
	
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where('upper(ativo) = "T"')
		@departamentos = Departamento.where('upper(ativo) = "T"')

		# Aqui criamos o Carrinho de Compras se ele não existir...
		if !defined?($CarrinhoCompras)
			$CarrinhoCompras = Array.new()
		end
		if !defined?($CarrinhoComprasQuant)
			$CarrinhoComprasQuant = Array.new()
		end	
		
		@totReg = $CarrinhoCompras.size
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @CarrinhoCompras}
		end
	end

	# Verifica se o carrinho de compras existe e o cria adicionando o produto...
	def new
		# Aqui criamos o Carrinho de Compras se ele não existir...
		if !defined?($CarrinhoCompras)
			$CarrinhoCompras = Array.new()
		end
		if !defined?($CarrinhoComprasQuant)
			$CarrinhoComprasQuant = Array.new()
		end	
		create()
		redirect_to "/compras?pd=" + Admloja.first.mcab.to_s
	end
	
	# Adiciona um item no carrinho de compras
	def create
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where('upper(ativo) = "T"')
		@departamentos = Departamento.where('upper(ativo) = "T"')
		if !defined?($CarrinhoCompras)
			$CarrinhoCompras = Array.new()
			@totReg = 0
		end
		if !defined?($CarrinhoComprasQuant)
			$CarrinhoComprasQuant = Array.new()
		end	
		
		@totReg = $CarrinhoCompras.size
		@prod = params[:prod]
		$CarrinhoCompras[@totReg] = Produt.find(@prod.to_i).id # ID do Produto
		$CarrinhoComprasQuant[@totReg] = 1 # QUANTIDADE
	end

	# alterar a quantidade de itens comprados
	def alterar
		if params[:item] == nil or params[:item] == ""
			redirect_to "/compras?pd=" + Admloja.first.mcab.to_s
			return
		end	
		if params[:quant] == nil or params[:quant] == ""
			redirect_to "/compras?pd=" + Admloja.first.mcab.to_s
			return
		end	
	
		item = params[:item].strip.to_i
		quant = params[:quant].strip.to_i
		
		$CarrinhoComprasQuant[item - 1] = quant
		
		# Verificando se a quantidade é zero ou negativo...
		if $CarrinhoComprasQuant[item - 1] <= 0
			$CarrinhoCompras[item - 1] = ""
			$CarrinhoComprasQuant[item - 1] = 0			
			$CarrinhoCompras.delete("")			# APAGANDO ITENS DO CARRINHO
			$CarrinhoComprasQuant.delete(0)		# APAGANDO Quantidade referente a item
		end
		
		redirect_to "/compras?pd=" + Admloja.first.mcab.to_s
	end
	
	# Retira um item do carrinho	
	def retirar
		vt = params[:id]
		$CarrinhoCompras[vt.to_i] = ""
		$CarrinhoComprasQuant[vt.to_i] = 0
			$CarrinhoCompras.delete("")			# APAGANDO ITENS DO CARRINHO
			$CarrinhoComprasQuant.delete(0)		# APAGANDO Quantidade referente a item
		redirect_to "/compras?pd=" + Admloja.first.mcab.to_s
	end
	
	# Apaga todos os itens do carrinho
	def limpar
		for ct in (0..($CarrinhoCompras.size - 1))
			$CarrinhoCompras[ct] = ""
		end
		for ct in (0..($CarrinhoComprasQuant.size - 1))
			$CarrinhoComprasQuant[ct] = 0
		end
		
			$CarrinhoCompras.delete("")		# APAGANDO ITENS DO CARRINHO
			$CarrinhoComprasQuant.delete(0)		# APAGANDO Quantidade referente a item
		redirect_to "/compras?pd=" + Admloja.first.mcab.to_s
	end
	
	
end
