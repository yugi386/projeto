class DepartamentosController < ApplicationController

	before_filter :authenticate
	layout "pad2"	# Definindo layout
	
	# APRESENTANDO TODOS OS REGISTROS:
	def index
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
	
		if @pesq == nil or @pesq.strip == ""
			@departamentos = Departamento.all		# Aqui sao apresentados todos os registros
		else
			# filtragem por nome
			@pesq = @pesq.strip
			@departamentos = Departamento.where("nome LIKE ?",'%'+@pesq+'%') # evitando sql injection
		end

		@totCli = @departamentos.size		# Aqui temos o total de departamentos...		
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @departamentos}
		end
	end
	
	# 
	def paginacao
		#if @pesq == nil or @pesq.strip == ""
		@page = Admloja.first.pagadm		# Definindo Numero de Registros a Exibir na Pagina
		#else
		#	@page = @departamentos.size		# Definindo Numero de Registros a Exibir na Pagina
		#end
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @departamentos.size
			@page = @departamentos.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@departamentos.size - 1)
			tmp = @departamentos.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na pagina
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @departamentos.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @departamentos[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		@departamento = Departamento.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @departamento}
		end
	end

	# CRIANDO UM NOVO REGISTRO VAZIO:	
	def new
		@departamento = Departamento.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml {render :xml => @departamento}
		end
	end
	
	# FUncao UXILIAR DE EDIcao:	
	def edit
		@departamento = Departamento.find(params[:id])
	end
	
	# GRAVANDO UM NOVO REGISTRO:
	def create

		@departamento = Departamento.new(params[:departamento])
		respond_to do |format|
			if @departamento.save
				format.html {redirect_to(@departamento, :notice => 'Registro incluído com Sucesso!')}
				format.xml {render :xml => @departamento, :status => :created, :location => @departamento}
			else
				format.html {render :action => "new"}
				format.xml {render :xml => @departamento.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# ATUALIZANDO UM REGISTRO:
	def update
		@departamento = Departamento.find(params[:id])
		respond_to do |format|
			if @departamento.update_attributes(params[:departamento])
				format.html {redirect_to(@departamento, :notice => 'Registro alterado com Sucesso!')}
				format.xml {head :ok}
			else
				format.html {render :action => "edit"}
				format.xml {render :xml => @departamento.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# DELETANDO UM REGISTRO:
	# DELETE /departamentos/1
  # DELETE /departamentos/1.json
  
	def destroy
		@departamento = Departamento.find(params[:id])
		@departamento.destroy
		
		respond_to do |format|
			format.html { redirect_to departamentos_url }
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
