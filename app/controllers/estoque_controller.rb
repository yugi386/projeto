class EstoqueController < ApplicationController

	before_filter :authenticate
	layout "pad2"	# Definindo layout
	
	# APRESENTANDO TODOS OS REGISTROS:
	def index
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
	
		if @pesq == nil or @pesq.strip == ""
			@estoques = Produt.all		# Aqui sao apresentados todos os registros
		else
			# filtragem por nome
			@pesq = @pesq.strip
			@estoques = Produt.where("nome LIKE ? or codigo = ?",'%'+@pesq+'%',@pesq) # evitando sql injection
		end

		@totCli = @estoques.size		# Aqui temos o total de registros
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @estoques}
		end
	end
	
	# 
	def paginacao
		#if @pesq == nil or @pesq.strip == ""
		@page = Admloja.first.pagadm		# Definindo Numero de Registros a Exibir na Pagina
		#else
		#	@page = @estoques.size		# Definindo Numero de Registros a Exibir na Pagina
		#end
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @estoques.size
			@page = @estoques.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@estoques.size - 1)
			tmp = @estoques.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na pagina
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @estoques.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @estoques[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		@estoque = Produt.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @estoque}
		end
	end

	# FUncao UXILIAR DE EDIcao:	
	def edit
		@estoque = Produt.find(params[:id])
	end
	
	# ATUALIZANDO UM REGISTRO:
	def update
		@estoque = Produt.find(params[:id])
		
		respond_to do |format|
			if @estoque.update_attributes(params[:produt])
				format.html {redirect_to("/estoque/"+@estoque.id.to_s, :notice => 'Operação realizada com Sucesso!')}
				format.xml {head :ok}
			else
				format.html {render :action => "edit"}
				format.xml {render :xml => @estoque.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	protected
	def authenticate
		if session[:logged] == true
			true
		else
			redirect_to "/login"
		end	
	end			
end
