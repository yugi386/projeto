class LinksController < ApplicationController
	before_filter :authenticate
	layout "pad2"	# Definindo layout
	
	# APRESENTANDO TODOS OS REGISTROS:
	def index
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
	
		if @pesq == nil or @pesq.strip == ""
			@links = Link.all 	# Aqui sao apresentados todos os registros
		else
			# filtragem por nome
			@pesq = @pesq.strip
			@links = Link.where("texto LIKE ?",'%'+@pesq+'%') # evitando sql injection
		end

		@totCli = @links.size		# Aqui temos o total de registros
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @links}
		end
	end
	
	# 
	def paginacao
		#if @pesq == nil or @pesq.strip == ""
		@page = Admloja.first.pagadm		# Definindo Numero de Registros a Exibir na Pagina
		#else
		#	@page = @links.size		# Definindo Numero de Registros a Exibir na Pagina
		#end
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @links.size
			@page = @links.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@links.size - 1)
			tmp = @links.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na pagina
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @links.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @links[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		@link = Link.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @link}
		end
	end

	# CRIANDO UM NOVO REGISTRO VAZIO:	
	def new
		@link = Link.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml {render :xml => @link}
		end
	end
	
	# FUncao UXILIAR DE EDIcao:	
	def edit
		@link = Link.find(params[:id])
	end
	
	# GRAVANDO UM NOVO REGISTRO:
	def create

		@link = Link.new(params[:link])
		respond_to do |format|
			if @link.save
				format.html {redirect_to(@link, :notice => 'Registro incluído com Sucesso!')}
				format.xml {render :xml => @link, :status => :created, :location => @link}
			else
				format.html {render :action => "new"}
				format.xml {render :xml => @link.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# ATUALIZANDO UM REGISTRO:
	def update
		@link = Link.find(params[:id])
		respond_to do |format|
			if @link.update_attributes(params[:link])
				format.html {redirect_to(@link, :notice => 'Registro alterado com Sucesso!')}
				format.xml {head :ok}
			else
				format.html {render :action => "edit"}
				format.xml {render :xml => @link.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# DELETANDO UM REGISTRO:
  
	def destroy
		@link = Link.find(params[:id])
		@link.destroy
		
		respond_to do |format|
			format.html { redirect_to links_url }
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
