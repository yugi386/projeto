class Section < ActiveRecord::Base

	default_scope order('upper(sections.nome) ASC') 	# ordem de listagem dos departamentos.

	# RELACIONAMENTOS:
	belongs_to :departamento
	has_many :produt

	# ROTINAS DE VALIDACAO DE DADOS:

	# ValidaCAO do Nome:
	validates_presence_of  :nome, :message => "da Seção deve ser preenchido!"
	validates_length_of :nome, :in => 5..50, :message => "deve ter tamanho minimo de 5 e maximo de 50 caracteres!"
	validates_length_of :descricao, :in => 0..500, :message => "deve ter tamanho maximo de 500 caracteres!"
	validate :validaDestaque
	# Verifica se o Seção está cadastrado considerando maiusculas e minusculas como iguais...
	validates_uniqueness_of :nome, :case_sensitive => false,  :message => "ja esta cadastrado!"  
	
	# Rotina para UPLOAD de imagens com PAPERCLIP PLUGIN...
	has_attached_file :arquivo    # para especificar outro path use == :path => ":rails_root/public/images/departamentos/:filename"
	

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
