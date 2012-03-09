require 'digest'	# biblioteca para tirar hash das senhas

class Cliente < ActiveRecord::Base

	default_scope order('upper(clientes.nome) ASC')	# ordem de listagem dos clientes
	
	# ROTINAS DE VALIDAÇÃO DE DADOS:

	# Validação do Nome - Razão Social:
	validates_presence_of  :nome, :message => "ou Razao Social deve ser preenchido!"
	validates_length_of :nome, :in => 5..50, :message => "deve ter tamanho minimo de 5 e maximo de 50 caracteres!"
	validates_length_of :obs, :in => 0..1000, :message => "deve ter tamanho maximo de 1000 caracteres!"
		
	validate :validaCNPJ	# Validacao personalizada CNPJ
	validate :validaCPF		# Validacao personalizada CPF
	validate :validaContato	# Validacao personalizada CONTATO
	validate :validaRG		# Validacao personalizada RG
	validate :validaEndereco	# Validacao personalizada Endereco
	validate :validaTelefone	# Validacao personalizada Telefone
	
	# Validacao de Email.
	validates_length_of :email, :in => 4..50, :message => "deve ter tamanho minimo de 4 e maximo de 50 caracteres!"
	validates_uniqueness_of :email, :message => "ja esta cadastrado!"
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
		if !cnpj.blank? and cnpj.size != 14 and pessoa == "J"
			errors.add(:cnpj, "deve ter 14 numeros (sem pontos ou barras)!") 
			return
		end	
		
		if !verN(cnpj) and !cnpj.strip.blank?
			errors.add(" ","O CNPJ deve conter apenas numeros!")
			return
		end	
		
		if cnpj.blank? and cpf.blank? and pessoa == "J"
			errors.add(:cnpj, "deve ser preenchido se nao ha CPF!") 
			return
		end	
		if pessoa == "J" and cnpj.blank?
			errors.add(:cnpj, "deve ser preenchido se for pessoa juridica!") 
			return
		end	
		if pessoa == "F" and !cnpj.blank?
			errors.add(:cnpj, "deve ser vazio se for pessoa fisica!") 
			return
		end	
		
		if pessoa == "J"
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
	end

	# ----------------------------------------------------------------------------------------------------------------------
	
	def validaCPF
		if !cpf.strip.blank? and cpf.size != 11
			errors.add(:cpf, "deve ter 11 numeros (sem pontos)!")
			return
		end	
		
		if !verN(cpf) and !cpf.strip.blank?
			errors.add(" ","O CPF deve conter apenas numeros!")
			return
		end	
		
		if cpf.strip.blank? and pessoa == "F"
			errors.add(:cpf, "deve ser preenchido se pessoa fisica!")
			return
		end	
		
		if pessoa == "F"
			# Validacao propriamente dita do formato do CPF 000.000.000-00
			tmp = 0
			cont = 0
			j = k = 0
			ct = 10
			# Calculando o primeiro digito veirificador do CPF
			
			while TRUE
				tmp = tmp + (cpf[cont..cont].to_i * ct)
				cont = cont + 1
				ct = ct -1
				if ct == 1
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
			ct = 11
			while TRUE
				tmp = tmp + (cpf[cont..cont].to_i * ct)
				cont = cont + 1
				ct = ct - 1
				if ct == 2
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
			
			if !(cpf[9..9].to_i == j and cpf[10..10].to_i == k)
				errors.add(:cpf, "invalido!!!")
			end
		end
	end

	# ----------------------------------------------------------------------------------------------------------------------
	
	def validaContato
		if (pessoa == "J" and contato.strip.size < 5) or (pessoa == "J" and contato.strip.size > 50)
			# errors.add(:contato, "da pessoa juridica deve ser preenchida (minimo 5 caracteres)!")	Abaixo temos alternativa para melhorar as mensagens de erro
			errors.add(" ","Responsavel da pessoa juridica deve ser preenchido (minimo 5, maximo 50 caracteres)!")
		end	
	end
	
	# ----------------------------------------------------------------------------------------------------------------------
	
	def validaRG
		if (pessoa == "F" and rg.strip.size < 4) or (pessoa == "F" and rg.strip.size > 20)
			errors.add(" ","O RG esta preenchido incorretamente!")
		end	
	end
	
	# ----------------------------------------------------------------------------------------------------------------------
	
	def validaEndereco
		
		# PESSOA FÍSICA
		if (pessoa == "F" and endereco.strip.size < 3) or (pessoa == "F" and endereco.strip.size > 70)
			errors.add(" ","O Endereco (end. residencial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (pessoa == "F" and bairro1.strip.size < 3) or (pessoa == "F" and bairro1.strip.size > 70)
			errors.add(" ","O bairro (end. residencial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (pessoa == "F" and cidade.strip.size < 3) or (pessoa == "F" and cidade.strip.size > 70)
			errors.add(" ","A cidade (end. residencial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (pessoa == "F" and cep.strip.size != 8  and cep.strip.size > 0)
			errors.add(" ","O CEP (END. RESIDENCIAL) esta preenchido incorretamente (deve ter somente numeros)!")
			return
		elsif (pessoa == "F" and cep.strip.size == 0)
			errors.add(" ","Preencha O CEP do END. RESIDENCIAL (deve ter somente numeros)!")
			return
		end	
		
		# PESSOA JURÍDICA:
		if (pessoa == "J" and endereco2.strip.size < 3) or (pessoa == "J" and endereco2.strip.size > 70)
			errors.add(" ","O Endereco (end. comercial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (pessoa == "J" and bairro2.strip.size < 3) or (pessoa == "J" and bairro2.strip.size > 70)
			errors.add(" ","O bairro (end. comercial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (pessoa == "J" and cidade2.strip.size < 3) or (pessoa == "J" and cidade2.strip.size > 70)
			errors.add(" ","A cidade (end. comercial) esta ausente ou preenchido incorretamente!")
			return
		end	
		if (pessoa == "J" and cep2.strip.size != 8 and cep2.strip.size > 0)
			errors.add(" ","O CEP (END. COMERCIAL) esta preenchido incorretamente (deve ter somente numeros)!")
			return
		elsif (pessoa == "J" and cep2.strip.size == 0)
			errors.add(" ","Preencha O CEP do END. COMERCIAL (deve ter somente numeros)!")
			return
		end	
		
		# Verificando se CEP possui somente numeros
		vetcep = [cep.strip, cep2.strip]

		if !verN(vetcep[0]) and pessoa == "F"
			errors.add(" ","O CEP (end. residencial) esta preenchido incorretamente (deve ter somente numeros)!")
		end
		
		if !verN(vetcep[1]) and pessoa == "J"
			errors.add(" ","O CEP (end. comercial) esta preenchido incorretamente (deve ter somente numeros)!")
		end
	end
	
	# ----------------------------------------------------------------------------------------------------------------------

	def validaTelefone
		# PESSOA FÍSICA
		
		if tel.strip.size != 0
			if (pessoa == "F" and tel.strip.size < 10) or (pessoa == "F" and tel.strip.size > 11)
				errors.add(" ","O Telefone (Residencial) esta preenchido incorretamente!")
			end	
			if !verN(tel) and pessoa == "F"
				errors.add(" ","O telefone (end. residencial) deve ter somente numeros!")
			end
		end

		if cel.strip.size != 0
			if (pessoa == "F" and cel.strip.size < 10) or (pessoa == "F" and cel.strip.size > 11)
				errors.add(" ","O Celular (Particular) esta preenchido incorretamente!")
			end	
			if !verN(cel) and pessoa == "F"
				errors.add(" ","O celular (end. residencial) deve ter somente numeros!")
			end
		end

		if cel.blank? and tel.blank?
			if pessoa == "F"
				errors.add(" ","Voce deve indicar um celular ou telefone para contato!!!")
			end	
		end
	
		#PESSOA JURÍDICA:
		if telefone2.strip.size != 0
			if (pessoa == "J" and telefone2.strip.size < 10) or (pessoa == "J" and telefone2.strip.size > 11)
				errors.add(" ","O Telefone (Comercial) esta preenchido incorretamente!")
			end	
			if !verN(telefone2) and pessoa == "J"
				errors.add(" ","O telefone (end. comercial) deve ter somente numeros!")
			end
		end

		if celular2.strip.size != 0
			if (pessoa == "J" and celular2.strip.size < 10) or (pessoa == "J" and celular2.strip.size > 11)
				errors.add(" ","O Celular (Comercial) esta preenchido incorretamente!")
			end
			if !verN(celular2) and pessoa == "J"
				errors.add(" ","O celular (end. comercial) deve ter somente numeros!")
			end			
		end

		if celular2.blank? and telefone2.blank?
			if pessoa == "J"
				errors.add(" ","Voce deve indicar um celular ou telefone para contato comercial!!!")
			end	
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
	# ROTINA DE FORMACAO DE BLOCO PARA PESQUISA: Nome + cpf + cnpj + email
	def tagP
		"#{nome} - #{cpf} - #{cnpj} - #{email}"
	end

end
