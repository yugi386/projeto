class LojaController < ApplicationController

	layout "loja"	# Definindo layout da loja
	
	# APRESENTANDO TODOS OS REGISTROS:
	def index
	
		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where('ativo  = "t"')
		@departamentos = Departamento.where('ativo  = "t"')

		# Verificando a ordem dos produtos:
		@ordem = params[:ordem]	
		if @ordem == nil or @ordem == ""
			@ordem = "1"	# ordem por destaque
		end
		
		# Pesquisa produtos em ordem de destaque e ativos...	
		@dep = params[:dep]	# recebemos a parametro do departamento...
		if @dep == nil or @dep == ""
			@dep = ""
		end
		
		@sec = params[:sec]	# recebemos a parametro do departamento...
		if @sec == nil or @sec == ""
			@sec = ""
		end
		
		# Regenciando registro e ordem a ser apresentada.
		if @dep == "" and @sec == ""
			@produtosx ||= Produt.send(:with_exclusive_scope) do  
				if @ordem == "1"
					Produt.all(:conditions => [ 'upper(ativo) = ?', "T" ], :order => 'destaque DESC' )
				elsif @ordem == "2"	
					Produt.all(:conditions => [ 'upper(ativo) = ?', "T" ], :order => 'vista ASC' )
				elsif @ordem == "3"	
					Produt.all(:conditions => [ 'upper(ativo) = ?', "T" ], :order => 'vista DESC' )
				elsif @ordem == "4"	
					Produt.all(:conditions => [ 'upper(ativo) = ?', "T" ], :order => 'prazo ASC' )
				elsif @ordem == "5"	
					Produt.all(:conditions => [ 'upper(ativo) = ?', "T" ], :order => 'prazo DESC' )					
				end
			end
		elsif @dep != ""  and @sec == ""
			@produtosx ||= Produt.send(:with_exclusive_scope) do 
				if @ordem == "1"
					Produt.all(:conditions => [ 'upper(ativo) = ? and departamento_id = ?', "T", @dep ], :order => 'destaque DESC')
				elsif @ordem == "2"						
					Produt.all(:conditions => [ 'upper(ativo) = ? and departamento_id = ?', "T", @dep ], :order => 'vista ASC')
				elsif @ordem == "3"											
					Produt.all(:conditions => [ 'upper(ativo) = ? and departamento_id = ?', "T", @dep ], :order => 'vista DESC')					
				elsif @ordem == "4"																
					Produt.all(:conditions => [ 'upper(ativo) = ? and departamento_id = ?', "T", @dep ], :order => 'prazo ASC')										
				elsif @ordem == "4"																					
					Produt.all(:conditions => [ 'upper(ativo) = ? and departamento_id = ?', "T", @dep ], :order => 'prazo DESC')
				end
			end	
		elsif @sec != "" and @dep == ""		
			@produtosx ||= Produt.send(:with_exclusive_scope) do 
				if @ordem == "1"
					Produt.all(:conditions => [ 'upper(ativo) = ? and section_id = ?', "T", @sec ], :order => 'destaque DESC')
				elsif @ordem == "2"					
					Produt.all(:conditions => [ 'upper(ativo) = ? and section_id = ?', "T", @sec ], :order => 'vista ASC')				
				elsif @ordem == "3"										
					Produt.all(:conditions => [ 'upper(ativo) = ? and section_id = ?', "T", @sec ], :order => 'vista DESC')								
				elsif @ordem == "4"														
					Produt.all(:conditions => [ 'upper(ativo) = ? and section_id = ?', "T", @sec ], :order => 'prazo ASC')												
				elsif @ordem == "5"																			
					Produt.all(:conditions => [ 'upper(ativo) = ? and section_id = ?', "T", @sec ], :order => 'prazo DESC')																
				end	
			end
		end
		

		# rotina de filtragem de registros...
		@pesq = params[:pesq]	# Aqui recebemos o parametro via URL
		
		if @pesq == nil or @pesq.strip == ""
				# ROTINA PARA EXCLUIR OS PRODUTOS COM SEÇÕES OU DEPARTAMENTOS DESATIVADOS...
				@produtos = Array.new()
				ct = 0
				ct2 = 0
				while TRUE
					if Departamento.find(@produtosx[ct].departamento_id).ativo == true and Section.find(@produtosx[ct].section_id).ativo == true 
						@produtos[ct2] = @produtosx[ct]
						ct2 = ct2 + 1
					end
					
					ct = ct + 1
					if ct > @produtosx.size - 1
						break
					end		
				end
		else
			# No codigo abaixo nos temos a filtragem por nome, cpf, cnpj ou email.
			@pesq = @pesq.strip
			# ROTINA PARA EXCLUIR OS PRODUTOS COM SEÇÕES OU DEPARTAMENTOS DESATIVADOS...
			@produtos = Array.new()
			ct = 0
			ct2 = 0
			while TRUE
				if Departamento.find(@produtosx[ct].departamento_id).ativo == true and Section.find(@produtosx[ct].section_id).ativo == true 
					if @produtosx[ct].codigo == @pesq or @produtosx[ct].nome.upcase.include? @pesq.upcase
						@produtos[ct2] = @produtosx[ct]
						ct2 = ct2 + 1
					end	
				end
				ct = ct + 1
				if ct > @produtosx.size - 1
					break
				end		
			end
		end

		@totReg = @produtos.size		# Aqui temos o total de Clientes...		
		paginacao()	# Funcao de paginacao
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml {render :xml => @produtos}
		end
	end
	
	# 
	def paginacao

		@page = Admloja.first.pagloja		# Definindo Numero de Registros a Exibir na Pagina
		
		@pag = params[:pag]	# Aqui recebemos o parametro via URL
		if @pag == nil
			@pag = 0
		elsif @pag.strip == ""
			@pag = 0
		end
		
		# Codigo para limitar os registros ao seu total.
		if @page > @produtos.size
			@page = @produtos.size
		end	
		
		if @pag.to_i < 0
			@pag = "0"
		end	

		if @pag.to_i > (@produtos.size - 1)
			tmp = @produtos.size - 1
			@pag = tmp.to_s
		end	
		
		@colecao = Array.new(@page)

		# Prenche o vetor com as ids dos registros a serem exibidos na pagina...
		inicio = 0 + @pag.to_i
		fim = @page + @pag.to_i - 1
		
		@colecao = Array.new(@page)
		cont = 0
		tmp = @produtos.size - 1
		
		for ct in (inicio..fim)
			@colecao[cont] = @produtos[ct].id
			cont = cont + 1
			if ct == tmp
				break
			end	
		end
	end

	# mostra um produto individual:	
	def show
		# Mapeando Secoes:
		@secoes = Section.where('ativo  = "t"')
		@departamentos = Departamento.where('ativo  = "t"')
		
		@produt = Produt.find(params[:id])
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml {render :xml => "/loja"}
		end
		
	end
	
end
