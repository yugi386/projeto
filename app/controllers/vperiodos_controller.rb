class VperiodosController < ApplicationController

	before_filter :authenticate
	layout 'pad2'

	def index
		@dataini = params[:dataini]
		@datafim = params[:datafim]
		
		if @dataini == nil or @dataini == ""
			@dataini = ""
		else
			@dataini = @dataini[6..9] + "/" + @dataini[3..4] + "/" + @dataini[0..1]
		end

		if @datafim == nil or @datafim == ""
			@datafim = ""
		else
			@datafim = @datafim[6..9] + "/" + @datafim[3..4] + "/" + @datafim[0..1]		
		end
		
		if @dataini == "" and @datafim == ""
			@vendas = Venda.where('status == "C"').all	# Somente vendas confirmadas.
		elsif @dataini != "" and @datafim == ""	
			@vendas = Venda.where('status == "C" and data >= ?',@dataini).all	# Somente vendas confirmadas.
		elsif @dataini == "" and @datafim != ""	
			@vendas = Venda.where('status == "C" and data <= ?',@datafim).all	# Somente vendas confirmadas.
		else
			@vendas = Venda.where('status == "C" and data <= ? and data >= ?',@dataini,@datafim).all	# Somente vendas confirmadas.
		end		
		
		@totCli = @vendas.size		# Aqui temos o total de vendas
		paginacao()	# Funcao de paginacao
		
	end

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
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		@venda = Venda.find(params[:id])
		@item = Item.where('venda_id = ?',@venda.id.to_s).all
	end

		def destroy

		# Apagando a venda e seus itens...	
		@id = params[:id]
		@venda = Venda.find(params[:id])
		@venda.destroy
		
		# Apagando Itens:
		@item = Item.where("venda_id = ?",@id).all
		
			@item.each do |f|
				f.destroy	# Apagando item.
			end	
		
		respond_to do |format|
			format.html { redirect_to "/vperiodos?pd=1" }
			format.xml { head :no_content }
		end
	
	end
	
	protected
	def authenticate
		if session[:logged] == true
			true
		else
			redirect_to "/loja"
		end	
	end	

end
