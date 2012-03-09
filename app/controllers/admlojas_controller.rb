class AdmlojasController < ApplicationController

	layout "pad2"	# Definindo layout
	before_filter :authenticate
	
	# APRESENTANDO TODOS OS REGISTROS:
	def index

		@admlojas = Admloja.all		# Aqui é a apresentação de todos os Registros...

		@totCli = @admlojas.size		# Aqui temos o total de registros
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @admlojas}
		end
	end
	
	# 
	def paginacao

		@page = 3		# Definindo Número de Registros a Exibir na Página
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @admlojas.size
			@page = @admlojas.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@admlojas.size - 1)
			tmp = @admlojas.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na página...
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @admlojas.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @admlojas[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		@admloja = Admloja.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @admloja}
		end
	end

	# CRIANDO UM NOVO REGISTRO VAZIO:	
	def new
		@admloja = Admloja.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml {render :xml => @admloja}
		end
	end
	
	# FUncao UXILIAR DE EDIcao:	
	def edit
		@admloja = Admloja.find(params[:id])
	end
	
	# GRAVANDO UM NOVO REGISTRO:
	def create
		@admloja = Admloja.new(params[:admloja])
	
		respond_to do |format|
			if @admloja.save
				format.html {redirect_to(@admloja, :notice => 'Registro incluído com Sucesso!')}
				format.xml {render :xml => @admloja, :status => :created, :location => @admloja}
			else
				format.html {render :action => "new"}
				format.xml {render :xml => @admloja.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# ATUALIZANDO UM REGISTRO:
	def update
		@admloja = Admloja.find(params[:id])
		respond_to do |format|
			if @admloja.update_attributes(params[:admloja])
				format.html {redirect_to(@admloja, :notice => 'Registro alterado com Sucesso!')}
				format.xml {head :ok}
			else
				format.html {render :action => "edit"}
				format.xml {render :xml => @admloja.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# DELETANDO UM REGISTRO:

  
	def destroy
		@admloja = Admloja.find(params[:id])
		@admloja.destroy
		
		respond_to do |format|
			format.html { redirect_to admlojas_url }
			format.xml { head :no_content }
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
