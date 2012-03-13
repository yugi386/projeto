class ClientesController < ApplicationController

	before_filter :authenticate

	# Utilizando dois layouts em um controller:	
	layout :choose_layout

   def choose_layout
     if session[:logged] != true
       return 'loja'
     else
       return 'pad2'
     end
   end
	
	def PesqSecDep()	# Carrega informações do layout da loja
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")		
	end
		
	# APRESENTANDO TODOS OS REGISTROS:
	def index
		if session[:logged] != true
			redirect_to("/loja")
			return
		end
		
		PesqSecDep()
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
	
		if @pesq == nil or @pesq.strip == ""
			@clientes = Cliente.all		# Aqui é a apresentação de todos os Registros...
		else
			# No código abaixo nós temos a filtragem por nome, cpf, cnpj ou email.
			@pesq = @pesq.strip
			@clientes = Cliente.where("nome LIKE ? or cpf = ? or cnpj = ? or email = ?",'%'+@pesq+'%',@pesq,@pesq,@pesq) # evitando sql injection
		end
		
		@totCli = @clientes.size		# Aqui temos o total de Clientes...		
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @clientes}
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
		if @page > @clientes.size
			@page = @clientes.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@clientes.size - 1)
			tmp = @clientes.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na página...
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @clientes.size - 1
		for ct in (inicio..fim)
			@colecao[cont] = @clientes[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end

	end
	
	# APRESENTANDO UMA FICHA INDIVIDUAL:
	def show
		PesqSecDep()
		# Validação para permitir o acesso de clientes logados.
		if session[:logged] == true
			@cliente = Cliente.find(params[:id])
		else
			if session[:logcli] != 0 and session[:logcli] != nil
				@cliente = Cliente.find(session[:logcli])
			else
				redirect_to("/loja")
				return
			end	
		end		
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => @cliente}
		end
	end

	# CRIANDO UM NOVO REGISTRO VAZIO:	
	def new
		PesqSecDep()
		@cliente = Cliente.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml {render :xml => @cliente}
		end
	end
	
	# FUncao UXILIAR DE EDIcao:	
	def edit
		PesqSecDep()
		# Validação para permitir o acesso de clientes logados.
		if session[:logged] == true
			@cliente = Cliente.find(params[:id])
		else
			if session[:logcli] != 0 and session[:logcli] != nil
				@cliente = Cliente.find(session[:logcli])
			else
				redirect_to("/loja")
				return
			end	
		end		

	end
	
	# GRAVANDO UM NOVO REGISTRO:
	def create
		PesqSecDep()
		@cliente = Cliente.new(params[:cliente])
		
		respond_to do |format|
			if @cliente.save
				format.html {redirect_to(@cliente, :notice => 'Registro incluído com Sucesso!')}
				format.xml {render :xml => @cliente, :status => :created, :location => @cliente}
			else
				format.html {render :action => "new"}
				format.xml {render :xml => @cliente.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# ATUALIZANDO UM REGISTRO:
	def update
		PesqSecDep()
		# Validação para permitir o acesso de clientes logados.
		if session[:logged] == true
			@cliente = Cliente.find(params[:id])
		else
			if session[:logcli] != 0 and session[:logcli] != nil
				@cliente = Cliente.find(session[:logcli])
			else
				redirect_to("/loja")
				return
			end	
		end		

		respond_to do |format|
			if @cliente.update_attributes(params[:cliente])
				format.html {redirect_to(@cliente, :notice => 'Registro alterado com Sucesso!')}
				format.xml {head :ok}
			else
				format.html {render :action => "edit"}
				format.xml {render :xml => @cliente.erros, :status => :unprocessable_entity }
			end		
		end
	end
	
	# DELETANDO UM REGISTRO:
	# DELETE /clientes/1
  # DELETE /clientes/1.json
  
	def destroy
		if session[:logged] != true
			redirect_to("/loja")
			return
		end

		PesqSecDep()
		@cliente = Cliente.find(params[:id])
		@cliente.destroy
		
		respond_to do |format|
			format.html { redirect_to clientes_url }
			format.xml { head :no_content }
		end
	end

	protected
	def authenticate
		if session[:logged] == true or (session[:logcli] == nil or session[:logcli] == 0)
			true
		else
			true
			# redirect_to "/login"
		end	
	end	
	
end
