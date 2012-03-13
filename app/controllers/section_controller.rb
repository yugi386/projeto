class SectionController < ApplicationController

	layout "pad2"	# Definindo layout
	before_filter :authenticate
		
	# APRESENTANDO TODOS OS REGISTROS:
	def index
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
	
		if @pesq == nil or @pesq.strip == ""
			@sections = Section.all		# Aqui sao apresentados todos os registros
		else
			# filtragem por nome
			@pesq = @pesq.strip
			@sections = Section.where("nome LIKE ?",'%'+@pesq+'%') # evitando sql injection
		end

		@totCli = @sections.size		# Aqui temos o total de registros.
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @sections}
		end
	end
	
	# 
	def paginacao
		#if @pesq == nil or @pesq.strip == ""
		@page = Admloja.first.pagadm		# Definindo Numero de Registros a Exibir na Pagina
		#else
		#		@page = @sections.size		# Definindo Numero de Registros a Exibir na Pagina
		#	end
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @sections.size
			@page = @sections.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@sections.size - 1)
			tmp = @sections.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na pagina
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @sections.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @sections[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		@section = Section.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @section}
		end
	end

	# CRIANDO UM NOVO REGISTRO VAZIO:	
	def new
		@section = Section.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml {render :xml => @section}
		end
	end
	
	# FUncao UXILIAR DE EDIcao:	
	def edit
		@section = Section.find(params[:id])
	end
	
	# GRAVANDO UM NOVO REGISTRO:
	def create

		@section = Section.new(params[:section])
		respond_to do |format|
			if @section.save
				format.html {redirect_to(@section, :notice => 'Registro incluído com Sucesso!')}
				format.xml {render :xml => @section, :status => :created, :location => @section}
			else
				format.html {render :action => "new"}
				format.xml {render :xml => @section.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# ATUALIZANDO UM REGISTRO:
	def update
		@section = Section.find(params[:id])
		respond_to do |format|
			if @section.update_attributes(params[:section])
				format.html {redirect_to(@section, :notice => 'Registro alterado com Sucesso!')}
				format.xml {head :ok}
			else
				format.html {render :action => "edit"}
				format.xml {render :xml => @section.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# DELETANDO UM REGISTRO:
  
	def destroy
		@section = Section.find(params[:id])
		@section.destroy
		
		respond_to do |format|
			format.html { redirect_to "/section" }
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
