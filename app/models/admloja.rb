require 'digest'	# biblioteca para tirar hash das senhas

class Admloja < ActiveRecord::Base
default_scope order('upper(admlojas.nome) ASC')	# ordem de listagem dos clientes
	
	# ROTINAS DE VALIDAÇÃO DE DADOS:

	# Validação do Nome - Razão Social:
	validates_presence_of  :nome, :message => "ou Razao Social deve ser preenchido!"
	validates_presence_of  :cnpj, :message => "deve ser preenchido!"
	validates_length_of :nome, :in => 5..50, :message => "deve ter tamanho minimo de 5 e maximo de 50 caracteres!"
	validates_length_of :obs, :in => 0..1000, :message => "deve ter tamanho maximo de 1000 caracteres!"
		
	validate :validaCNPJ	# Validacao personalizada CNPJ
	validate :validaEndereco	# Validacao personalizada Endereco
	validate :validaTelefone	# Validacao personalizada Telefone
	
	# Validacao de Email.
	validates_length_of    :email, :in => 4..50, :message => "deve ter tamanho minimo de 4 e maximo de 50 caracteres!"
	if :email.blank?
		validates_uniqueness_of :email, :message => "ja esta cadastrado!"
	end	
	validates :email, :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
		
	# Validacao de senha:
	validates_presence_of  :password, :message => "deve ser preenchido!"
	validates_length_of    :password, :in => 6..30, :message => "deve ter tamanho minimo de 6 e maximo de 30 caracteres!"
	validates_confirmation_of :password
	validates_presence_of     :password_confirmation

	before_save :cifra_senha
	
	def cifra_senha
		if password == nil
			return
		end
		if password.size != 0
			self.password = Digest::SHA1.hexdigest("a74hdc63" + password + "dh46vhf86g")	# atenção para a chamada self
		end
	end
	
	
	# ----------------------------------------------------------------------------------------------------------------------		
	# ABAIXO TEMOS OS METODOS DE VALIDACAO PERSONALIZADOS:
	# ----------------------------------------------------------------------------------------------------------------------
	
	def validaCNPJ
		if !cnpj.blank? and cnpj.size != 14
			errors.add(:cnpj, "deve ter 14 numeros (sem pontos ou barras)!") 
			return
		end	
		
		if !verN(cnpj) and !cnpj.strip.blank?
			errors.add(" ","O CNPJ deve conter apenas numeros!")
			return
		end	
		
		if cnpj.blank?
			errors.add(:cnpj, "deve ser preenchido!") 
			return
		end	
		
			# Validacao propriamente dita do formato do CNPJ 11.222.333/0001-XX
			tmp = 0
			cont = 0
			j = k = 0
			ct = 0
			vet = [5,4,3,2,9,8,7,6,5,4,3,2]
			
			# Calculando o primeiro digito verificador do CNPJ
			
			while TRUE
				tmp = tmp + (cnpj[cont..cont].to_i * vet[ct])
				cont = cont + 1
				ct = ct + 1
				if ct > 11 
					break
				end	
			end	
			tmp = tmp % 11
									
			if tmp == 0 or tmp == 1
				j = 0
			else
				j = 11 - tmp
			end
			
			# Calculando o segundo digito:
			tmp = 0
			cont = 0
			ct = 0
			vet = [6,5,4,3,2,9,8,7,6,5,4,3,2] 
			
			while TRUE
				tmp = tmp + (cnpj[cont..cont].to_i * vet[ct])
				cont = cont + 1
				ct = ct + 1
				if ct > 11
					break
				end
			end	
			tmp = tmp + (2*j)
			tmp = tmp % 11
			if tmp == 0 or tmp == 1
				k = 0
			else
				k = 11 - tmp
			end
			
			if !(cnpj[12..12].to_i == j and cnpj[13..13].to_i == k)
				errors.add(:cnpj, "invalido!!!")
			end

	end

	# ----------------------------------------------------------------------------------------------------------------------
	

	def validaEndereco
		
		# PESSOA JURÍDICA:
		if (endereco.strip.size < 3) or (endereco.strip.size > 70)
			errors.add(" ","O Endereco (end. comercial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (bairro.strip.size < 3) or (bairro.strip.size > 70)
			errors.add(" ","O bairro (end. comercial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (cidade.strip.size < 3) or (cidade.strip.size > 70)
			errors.add(" ","A cidade (end. comercial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (cep.strip.size != 8 and cep.strip.size > 0)
			errors.add(" ","O CEP (END. COMERCIAL) esta preenchido incorretamente (deve ter somente numeros)!")
			return
		elsif (cep.strip.size == 0)
			errors.add(" ","Preencha O CEP do END. COMERCIAL (deve ter somente numeros)!")
			return
		end	
		
		# Verificando se CEP possui somente numeros
		vetcep = [cep.strip]

		if !verN(vetcep[0])
			errors.add(" ","O CEP esta preenchido incorretamente (deve ter somente numeros)!")
		end
		
	end
	
	# ----------------------------------------------------------------------------------------------------------------------

	def validaTelefone
		
		if tel.strip.size != 0
			if tel.strip.size < 10 or tel.strip.size > 11
				errors.add(" ","O Telefone esta preenchido incorretamente!")
			end	
			if !verN(tel)
				errors.add(" ","O telefone deve ter somente numeros!")
			end
		end

		if cel.strip.size != 0
			if cel.strip.size < 10 or cel.strip.size > 11
				errors.add(" ","O Celular (Particular) esta preenchido incorretamente!")
			end	
			if !verN(cel)
				errors.add(" ","O celular deve ter somente numeros!")
			end
		end

		if fax.strip.size != 0
			if fax.strip.size < 10 or fax.strip.size > 11
				errors.add(" ","O FAX esta preenchido incorretamente!")
			end	
			if !verN(fax)
				errors.add(" ","O FAX deve ter somente numeros!")
			end
		end
		
		if cel.blank? and tel.blank?
				errors.add(" ","Voce deve indicar um celular ou telefone para contato!!!")
		end
	
	end	
	
	# ----------------------------------------------------------------------------------------
	# VERIFICANDO SE UMA DADA STRING QUALQUER É UM NUMERO
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
		
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
	

end
