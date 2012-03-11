class PedidosController < ApplicationController

	layout "loja"	# Definindo layout
	before_filter :authenticate
	
	# Apresentando todos os pedidos do cliente...
	def index
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where('ativo  = "t"')
		@departamentos = Departamento.where('ativo  = "t"')

		@pedidos = Venda.where("cliente = ?",session[:logcli]).all		# Aqui é a apresentação de todos os Registros dlo cliente logado...

		@totpedidos = @pedidos.size
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @pedidos}
		end
	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where('ativo  = "t"')
		@departamentos = Departamento.where('ativo  = "t"')

		@pedido = Venda.find(params[:id])
		@item = Item.where('venda_id = ?',@pedido.id.to_s).all
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @pedido}
		end
	end
	
	def CancelarPedido	# Cancela o pedido de um cliente...
	# Mapeando Departamentos e Seções ativas
		@secoes = Section.where('ativo  = "t"')
		@departamentos = Departamento.where('ativo  = "t"')

		@pedido = Venda.find(params[:id])
		@item = Item.where('venda_id = ?',@pedido.id.to_s).all
		
		# Retornado os itens para o estoque:
		tam = @item.size - 1
		quant = 0
		for ct in (0..tam)
			quant = @item[ct].quant
			id = @item[ct].id
			
			@prod = Produt.find(@item[ct].idprod)
			@prod.quant = @prod.quant + quant
			@prod.save
			
			@item[ct].destroy
			# @item.save
		end
		
		# Deletando o pedido:
		@pedido.destroy
		@pedido.save
		
	end


	
	
	protected
	def authenticate
		if session[:logcli] != 0 and  session[:logcli] != nil
			true
		else
			redirect_to "/cliente_login"
		end	
	end	
	
end
