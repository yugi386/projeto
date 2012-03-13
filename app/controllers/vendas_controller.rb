class VendasController < ApplicationController

	before_filter :authenticate, :except => [:listar, :destroy, :abrir, :fechar, :show]
	# Utilizando dois layouts em um controller:	
	layout :choose_layout

   def choose_layout
     if session[:logged] != true
       return 'loja'
     else
       return 'pad2'
     end
   end

	
	def index
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")
		if !defined?($venda_erro)
			$venda_erro = Array.new
		end	
	end

	# alterar a quantidade de itens comprados
	def alterar
		if params[:item] == nil or params[:item] == ""
			redirect_to "/vendas?pd=" + Admloja.first.mcab.to_s
			return
		end	
		if params[:quant] == nil or params[:quant] == ""
			redirect_to "/vendas?pd=" + Admloja.first.mcab.to_s
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
		
		redirect_to "/vendas?pd=" + Admloja.first.mcab.to_s
	end
	
	# Retira um item do carrinho	
	def retirar
		vt = params[:id]
		$CarrinhoCompras[vt.to_i] = ""
		$CarrinhoComprasQuant[vt.to_i] = 0
			$CarrinhoCompras.delete("")			# APAGANDO ITENS DO CARRINHO
			$CarrinhoComprasQuant.delete(0)		# APAGANDO Quantidade referente a item
		redirect_to "/vendas?pd=" + Admloja.first.mcab.to_s
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
		redirect_to "/vendas?pd=" + Admloja.first.mcab.to_s
	end
	
	# Finaliza um pedido do cliente pela INTERNET ---------------------------------------------------------------------------------------
	def finalizar
			# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")

		@tipopag = params[:tipopag]				# tipo de pagamento (vista, prazo)

		if @tipopag == "1"	
			@formpag = "Pagamento à Vista - Boleto"
		elsif	@tipopag == "2"	
			@formpag = "Pagamento à Vista - Cartão de Débito"
		elsif	@tipopag == "3"	
			@formpag = "Pagamento à Vista - Cartão de Crédito"
		elsif	@tipopag == "4"	
			@formpag = "Pagamento à Prazo - Cartão de Crédito"
		end	
		
		@parcelas = params[:parcelas]			# parcelamento 
		@dadoscartao = params[:dadoscartao]		# dados do cartao
		
		tam = $CarrinhoCompras.size - 1
		total = 0
		for ct in (0..tam)
			if @tipopag.to_i <= 3
				total = totalVista($CarrinhoCompras,$CarrinhoComprasQuant)
			else
				total = totalPrazo($CarrinhoCompras,$CarrinhoComprasQuant)
			end			
		end
	
		# Calculando Frete:
		frete = 0
		if @tipopag.to_i <= 3
			frete = frete + calculafrete($CarrinhoCompras,1)	# vista
		else	
			frete = frete + calculafrete($CarrinhoCompras,2)	# prazo
		end
		
		# Verificando estoque:
		ct2 = 0
		$venda_erro = Array.new
		for ct in (0..tam)
			if Produt.find($CarrinhoCompras[ct]).quant < $CarrinhoComprasQuant[ct]	# Verifica quantidade insuficiente no estoque
				$venda_erro[ct2] = "Estoque insuficiente para o produto: " + Produt.find($CarrinhoCompras[ct]).nome +  " | MAXIMO: " + Produt.find($CarrinhoCompras[ct]).quant.to_s
				ct2 = ct2 + 1
			end
		end
	
		if $venda_erro.size > 0	# estoque insuficiente!
			redirect_to "/retornar"
			return
		end
		
		if validaDadosCartao().size != 0
			redirect_to "/retornar"
			return
		end

		# Realizando a operação de compra do cliente (Criando registro na tabela Vendas):
			@Vendas = Venda.new
			data = DateTime.now()
			@Vendas.data =  data.strftime(fmt='%F')
			@Vendas.cliente = session[:logcli]
			@Vendas.valor = total.to_i
			@Vendas.itens = tam + 1
			@Vendas.parcelas = @parcelas
			@Vendas.dadoscartao = @dadoscartao
			@Vendas.status = "A"
			@Vendas.frete = frete
			@Vendas.tipopag = @tipopag
			@Vendas.cliente_nome = Cliente.find(session[:logcli]).nome
			@Vendas.save
			@VendasId = Venda.last.id
		
		# Realizando a operação de compra do cliente (Registrando itens da compra - Tabela Itens):

		tam = $CarrinhoCompras.size - 1
		for ct in (0..tam)		
			@Items = Item.new
			
			@Items.venda_id = @VendasId		# chave estrangeira para tabela vendas
			
			@Items.idprod = Produt.find($CarrinhoCompras[ct]).id	# id do produto
			
			if @tipopag.to_i <= 3	# se preco a vista
				@Items.valor = desconto(Produt.find($CarrinhoCompras[ct]).vista, Produt.find($CarrinhoCompras[ct]).id)	# Verificando preco a vista do produto
			else
				@Items.valor = desconto(Produt.find($CarrinhoCompras[ct]).prazo, Produt.find($CarrinhoCompras[ct]).id)	# Verificando preco a prazo do produto
			end
			@Items.quant = $CarrinhoComprasQuant[ct]
			@Items.save
			
			# Dando baixa no estoque:
			
			@prod = Produt.find($CarrinhoCompras[ct])
			@prod.quant = @prod.quant - $CarrinhoComprasQuant[ct]
			@prod.save
		end	
		
	end
	
	# ----------------------------------------------------------------------------------------------------------------
	
	def listar # listando os pedidos de todos os clientes - AREA ADMINISTRATIVA
		if session[:logged] != true
			redirect_to("/loja")
			return
		end
				# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")

		
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
	
		if @pesq == nil or @pesq.strip == ""
			@vendas = Venda.all		# Aqui é a apresentação de todos os Registros...
		else
			# No código abaixo nós temos a filtragem por nome, cpf, cnpj ou email.
			@pesq = @pesq.strip
			@vendas = Venda.where("cliente_nome LIKE ?",'%'+@pesq+'%') # evitando sql injection e pesquisando pelo nome do cliente.
		end
		
		@totCli = @vendas.size		# Aqui temos o total de vendas
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @vendas}
		end
	end
	
	# 
	def paginacao
		#if @pesq == nil or @pesq.strip == ""
		@page = Admloja.first.pagadm		# Definindo Numero de Registros a Exibir na Pagina
		#else
		#		@page = @clientes.size		# Definindo Número de Registros a Exibir na Página
		#end
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @vendas.size
			@page = @vendas.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@vendas.size - 1)
			tmp = @vendas.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na página...
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @vendas.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @vendas[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
		
	def destroy
		if session[:logged] != true
			redirect_to("/loja")
			return
		end

		# Apagando a venda e seus itens...	
		@id = params[:id]
		@venda = Venda.find(params[:id])
		@venda.destroy
		
		# Apagando Itens:
		@item = Item.where("venda_id = ?",@id).all
		
			@item.each do |f|
				if @venda.status == "A"		# Se o pedido estiver aberto então devolve os produtos para o estoque
					# Devolvendo os itens para o estoque:
					@prod = Produt.find(f.idprod)
					@prod.quant = @prod.quant + f.quant
					@prod.save
				end		
				f.destroy	# Apagando item.
			end	
		
		respond_to do |format|
			format.html { redirect_to "/vendas_listar?pd=1" }
			format.xml { head :no_content }
		end
	
	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		if session[:logged] != true
			redirect_to("/loja")
			return
		end
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")

		@venda = Venda.find(params[:id])
		@item = Item.where('venda_id = ?',@venda.id.to_s).all
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @venda}
		end
	end
	
	def fechar
		if session[:logged] != true
			redirect_to("/loja")
			return
		end
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")

		@venda = Venda.find(params[:id])
		@venda.status = "C"
		@venda.save
		
		redirect_to("/vendas_listar")
		return
	end

	def abrir
		if session[:logged] != true
			redirect_to("/loja")
			return
		end
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")

		@venda = Venda.find(params[:id])
		@venda.status = "A"
		@venda.save
		
		redirect_to("/vendas_listar")
		return
	end
	
	# ----------------------------------------------------------------------------------------------------------------
	# Abaixo temos funções auxiliares:
	
	# calcula o total das compras a vista
	def totalVista(cp,quant)
		reg = cp.size - 1
		ret = 0
		for ct in (0..reg)
			ret = ret + (desconto(Produt.find(cp[ct]).vista, Produt.find(cp[ct]).id) * quant[ct])
		end
		return ret
	end
	
	# calcula o total das compras a prazo
	def totalPrazo(cp,quant)
		reg = cp.size - 1
		ret = 0
		for ct in (0..reg)
			ret = ret + (desconto(Produt.find(cp[ct]).prazo, Produt.find(cp[ct]).id) * quant[ct])
		end
		return ret
	end

	# Calculando o frete
	def calculafrete(carro,modopag)	# modopag = 1 = vista , 2 = prazo
		# verifica se o frete está ignorado pelo administrador.
		if Admloja.first.ufrete == 0
			return 0
		end
		
		# distingue pessoa fisica ou juridica
		if Cliente.find(session[:logcli]).pessoa == "F"
			estado = Cliente.find(session[:logcli]).estado
		else
			estado = Cliente.find(session[:logcli]).estado2
		end
		
		tam = carro.size - 1
		frete = 0	# Valor Inicial
		compras = 0
		for ct in (0..tam)
			frete = frete + locUF(estado,carro[ct])
		end

		if modopag == 1
			compras = totalVista($CarrinhoCompras,$CarrinhoComprasQuant)		
		else
			compras = totalPrazo($CarrinhoCompras,$CarrinhoComprasQuant)		
		end	
		
		if compras >= Admloja.first.freefrete 
			return 0
		else
			return frete
		end
	end
	
	
	# funcao para gerenciar o desconto para preco a vista ou a prazo
	def desconto(xpreco,pId)
		tg = Admloja.first.udesconto
		if tg == 0	# ignora desconto
			return xpreco
		elsif tg == 1 # Considera desconto para preco a vista
			ret = xpreco - Produt.find(pId).desconto
			return ret
		elsif tg == 2 # Considera desconto para preco a prazo
			ret = xpreco - Produt.find(pId).desconto
			return ret			
		end
	end
	
	# devolve o valor do frete de acordo com o estado do cliente
	def locUF(uf,prod)

		if "RS-PR-SC".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fsul
		elsif "MG-SP-RJ-ES".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fsudeste
		elsif "DF-GO-MT-MS".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fcentro
		elsif "AL-BA-CE-MA-PB-PE-PI-RN-SE".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fnordeste
		elsif "AC-AP-AM-PA-RO-RR-TO".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fnorte
		end
	end

	def validaDadosCartao
			$venda_erro = Array.new()
			ct = 0
			if @dadoscartao == nil and @tipopag.to_i == 4	# exige dados do cartao para compra a prazo
				$venda_erro[ct] = "Para comprar a Prazo E necessArio fornecer os Dados do CartAo de CrEdito!".upcase
				ct = ct + 1
				return $venda_erro
			end	
			
			if @dadoscartao == "" and @tipopag.to_i == 4	# exige dados do cartao para compra a prazo
				$venda_erro[ct] = "Para comprar a Prazo E necessArio fornecer os Dados do CartAo de CrEdito!".upcase
				ct = ct + 1
				return $venda_erro
			end	
			
			if @dadoscartao != nil and @tipopag.to_i < 2 and @dadoscartao != "" 	# pagamento boleto
				$venda_erro[ct] = "Nao forneCa dados de CartAo de CrEdito para pagamento A VISTA!".upcase
				ct = ct + 1
				return $venda_erro
			end	
			
			return $venda_erro
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
