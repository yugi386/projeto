class Produt < ActiveRecord::Base
	
	default_scope order('upper(nome) ASC') 	# ordem de listagem dos produtos.

	# RELACIONAMENTOS:
	belongs_to :departamento
	belongs_to :section

	# ROTINAS DE VALIDACAO DE DADOS:

	# ValidaCAO do Nome:
	validates_presence_of  :nome, :message => "do Produto deve ser preenchido!"
	validates_length_of :nome, :in => 4..150, :message => "deve ter tamanho minimo de 4 e maximo de 150 caracteres!"
	
	validates_presence_of  :modelo, :message => "do Produto deve ser preenchido!"
	validates_presence_of  :unidade, :message => "do Produto deve ser preenchida!"
	validates_presence_of  :custo, :message => "do Produto deve ser preenchido!"
	validates_presence_of  :prazo, :message => "do Produto deve ser preenchido!"
	validates_presence_of  :vista, :message => "do Produto deve ser preenchido!"
	validates_presence_of  :parcelas, :message => "do Produto devem ser preenchidas!"
	validates :parcelas, :fnorte, :fnordeste, :fsul, :fsudeste, :fcentro, :desconto, :numericality => true
		
	validates_length_of :descricao, :in => 50..8000, :message => "deve ter tamanho mínimo de 50 e maximo de 8000 caracteres!"
	validate :validaDestaque
	validate :validaEstoque
	
	# Verifica se o produto esta cadastrado considerando maiusculas e minusculas como iguais...
	validates_uniqueness_of :nome, :case_sensitive => false,  :message => "ja esta cadastrado!"  
	
	# Rotina para UPLOAD de imagens com PAPERCLIP PLUGIN...
	has_attached_file :arquivo    # para especificar outro path use == :path => ":rails_root/public/images/departamentos/:filename"
	
	# CALLBACKS:
	# O codigo abaixo realiza a geracao do codigo do produto automaticamente apos a gravacao.
	after_save :gera_codigo_do_produto
	after_save :gerenciaMovimento	# Verifica se houve movimentacao de estoque
	validate :validaEstoque
	validate :validaSecDep
	
	# validacao de departamentos e secoes...
	def validaSecDep
		@section = Section.where('id = ? and departamento_id = ?', section_id, departamento_id ).all	
		
		if @section.size == 0
			@sec = Section.where('departamento_id = ?', departamento_id ).all	
			msg = 13.chr + 10.chr + 13.chr + 10.chr
			@sec.each do |reg|
				msg = msg + reg.nome + " | "
			end
			
			errors.add(" ","Esta Sessão não pertence a este departamento!!! ----------------  Seções Válidas: " + msg)
			return
		end
	
	end
	
	# Metodo utilizado depois da criação do registro necessario para gerar o código do produto
	def gera_codigo_do_produto
		# @produt2 = Produt.where('codigo = "0" or codigo = NULL or codigo = ""').all	
		@produt2 = Produt.where("codigo = '0' or codigo = NULL").all	
		
		@produt2.each do |reg|
			tcod = 	reg.departamento_id.to_s + "." + reg.section_id.to_s + "." + reg.id.to_s
			reg.codigo = tcod
			reg.dataentrada = "2000-01-01 00:00:00"
			reg.entrada = 0
			reg.databaixa = "2000-01-01 00:00:00"
			reg.baixa = 0
			reg.datasaida = "2000-01-01 00:00:00"
			reg.saida = 0
			reg.quant = 0
			reg.verif = true
			reg.save
		end	
	end

	def gerenciaMovimento	# verificando movimentacao no estoque...
		@produt2 = Produt.where('verif = "f" or verif = "F" or verif = NULL').all	
		
		@produt2.each do |reg|
			tcod = (reg.entrada - reg.baixa)
			reg.quant = reg.quant + tcod
			reg.verif = true
			reg.save
		end	

	end	
	
	def validaEstoque()
		if id != nil
			if !verN(entrada.to_s) 
				errors.add(" ","A entrada deve corresponder a um número inteiro!")
				return
			end	
			if !verN(baixa.to_s)
				errors.add(" ","A Baixa deve corresponder a um número inteiro!")
				return
			end	
			if entrada < 0 or baixa < 0
				errors.add(" ","Entrada | Baixa não podem ser negativos!")
				return
			end
		end	
	end
	
	def validaDestaque
		if !verN(destaque.to_s)
			errors.add(" ","O destaque deve ser um número de 1 até 10!")
			return
		end	
		
		if verN(destaque.to_s)
			tmp = destaque
			if tmp < 1 or tmp > 10
				errors.add(" ","O destaque deve ser um número de 1 até 10!")
				return
			end	
		end	
	end
	
	# ----------------------------------------------------------------------------------------
	# VERIFICANDO SE UMA DADA STRING QUALQUER e NUMERO
	def verN(num)
		ret = true
		
		if num == nil
			return false
		end
		if num.strip.size == 0
			return false
		end
		
		tam = num.strip.size
		tam = tam -1 
		
		for ct in (0..tam)
			if num[ct..ct] != "0" and num[ct..ct] != "1" and num[ct..ct] != "2" and num[ct..ct] != "3" and num[ct..ct] != "4" and num[ct..ct] != "5" and num[ct..ct] != "6" and num[ct..ct] != "7" and num[ct..ct] != "8" and num[ct..ct] != "9"
				ret = false
				break
			end	
		end
		
		return ret
	end
		
	
end
