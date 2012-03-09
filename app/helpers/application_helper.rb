module ApplicationHelper

# METODO PARA FORMATAR TELEFONES - preparado para telefones de 10 e 11 digitos: -------------------------------------------------------------------------------------------------------------
	def formata_telefone(n_telefone) # '(00)0000-0000' ou '(00)0000-00000'
		if n_telefone != nil
			if n_telefone.strip.size == 10	
				tel_formatado = "("
				tel_formatado << n_telefone[0..1]
				tel_formatado << ")"
				tel_formatado << n_telefone[2..5]
				tel_formatado << "-"
				tel_formatado << n_telefone[6..9]
				return tel_formatado
			elsif n_telefone.strip.size == 11
				tel_formatado = "("
				tel_formatado << n_telefone[0..1]
				tel_formatado << ")"
				tel_formatado << n_telefone[2..5]
				tel_formatado << "-"
				tel_formatado << n_telefone[6..10]
				return tel_formatado
			else
				return n_telefone
			end	
		else
			return n_telefone
		end  
	end

	# METODO PARA A FORMATAȃO DO CEP NAS VIEWS... -------------------------------------------------------------------------------------------------------------
	def fCep(nCep) # '00.000-000'
		if nCep == nil
			return nCep
		end
		if nCep.strip.size == 8
			tCep = ""
			tCep = tCep + nCep[0..1] + "." + nCep[2..4]
			tCep = tCep + "-"
			tCep = tCep + nCep[5..7]
			return tCep
		else
			return nCep
		end	
	end
	
	# METODO PARA A FORMATAȃO DO CPF NAS VIEWS... -------------------------------------------------------------------------------------------------------------
	def fCpf(nCpf) # '000.000.000-00'
		if nCpf == nil
			return nCpf
		end
		if nCpf.strip.size == 11
			tCpf = ""
			tCpf = tCpf + nCpf[0..2] + "." + nCpf[3..5] + "." + nCpf[6..8]
			tCpf = tCpf + "-"
			tCpf = tCpf + nCpf[9..10]
			return tCpf
		else
			return nCpf
		end	
	end
	
	# METODO PARA A FORMATAȃO DO CNPJ NAS VIEWS... -------------------------------------------------------------------------------------------------------------
	def fCnpj(nCnpj)	# '00.000.000/0000-00'
		if nCnpj == nil
			return nCnpj
		end
		if nCnpj.strip.size == 14
			tC = ""
			tC = tC + nCnpj[0..1] + "." + nCnpj[2..4] + "." + nCnpj[5..7] + "/" + nCnpj[8..11]
			tC = tC + "-"
			tC = tC + nCnpj[12..13]
			return tC
		else
			return nCnpj
		end	
	end
	
	# METODO PARA A FORMATACAO DE MENSAGENS DE ERRO AO CRIAR OU EDITAR O FORMULARIO
	
	def tmsg(msg)
		if msg != nil
			msg = msg.strip.upcase
		end
		
		if msg == "EMAIL IS INVALID"
			return "Este e-mail e invalido!".upcase
		elsif msg == "password deve ser preenchido!".upcase
			return "Digite sua senha!!!".upcase
		elsif msg == "PASSWORD DEVE TER TAMANHO MINIMO DE 4 E MAXIMO DE 30 CARACTERES!".upcase
			return "senha deve ter entre 4 e 30 caracteres!".upcase
		elsif msg == "FNORTE IS NOT A NUMBER"
			return "Frete da Região Norte deve ser preenchido corretamente!".upcase
		elsif msg == "FNORDESTE IS NOT A NUMBER"
			return "Frete da Região Nordeste deve ser preenchido corretamente!".upcase
		elsif msg == "FSUL IS NOT A NUMBER"
			return "Frete da Região Sul deve ser preenchido corretamente!".upcase
		elsif msg == "FSUDESTE IS NOT A NUMBER"
			return "Frete da Região Sudeste deve ser preenchido corretamente!".upcase
		elsif msg == "FCENTRO IS NOT A NUMBER"
			return "Frete da Região Centro-Oeste deve ser preenchido corretamente!".upcase		
		elsif msg == "PASSWORD CONFIRMATION CAN'T BE BLANK"
			return "Digite a confirmação da senha!!!".upcase
		end
		
		return msg
	end
	
	def hPag(reg,xColecao)	# VERIFICA SE O REGISTRO CORRENTE
		ret = FALSE
		tam = xColecao.size - 1
		for ct in (0..tam)
			if reg == xColecao[ct]
				ret = TRUE
				break
			end	
		end	
		return ret
	end

	def minimo(xa)
		if xa.to_i < 0
			return "0"
		else
			xa.to_s
		end	
	end	
	
	def soma(xa,xb,total)
		tmp = xa + xb
		# return "0"
		if tmp <= total
			return tmp.to_s
		else
			return xa.to_s
		end	
	end	

# formatacao de moeda...
	def moeda(xvar)
			ret = ""
		
		if xvar == nil
			return xvar
		end	
		
		tam = xvar.to_s.strip.size - 1
		ver = false
		for ct in (0..tam)
			if xvar.to_s[ct] == "."
				ver = true
				break
			end
		end
		
		if ver == false
			ret = "R$ " + xvar.to_s + ".00"
			return ret
		end	
		
		if ct == tam
			ret = "R$ " + xvar.to_s + "00"
			return ret
		end	
		
		if ct == (tam - 1)
			ret = "R$ " + xvar.to_s + "0"
			return ret
		end	
		
		return "R$ " + format("%.2f", xvar)
	end
	
	# Apresenta o preco de acordo com as configurações!!!
	def preco(pVista,pPrazo,pId)
		config = Admloja.first.upreco
		
		if config == 0	# nao mostra preco
			return "Preço sob Consulta!"
		elsif config == 1	
			return "Preço: " + moeda(desconto(pVista,pId))
		elsif config == 2	
			return "Preço: " + moeda(desconto(pPrazo,pId))
		end
	end

	# Esta funcao verifica se o preco de um produto esta oculto
	def precoOculto(prod,valor)
		preco = Produt.find(prod).preco_oculto
		if preco	
			return "Preço sob Consulta!"
		else
			return valor
		end
	end
	
	# funcao para gerenciar o desconto para preco a vista ou a prazo
	def desconto(xpreco,pId)
		tg = Admloja.first.udesconto
		if tg == 0	# ignora desconto
			return xpreco
		elsif tg == 1 # Considera desconto para preco a vista
			ret = xpreco - Produt.find(pId).desconto
			return ret
		elsif tg == 2 # Considera desconto para preco a prazo
			ret = xpreco - Produt.find(pId).desconto
			return ret			
		end
		
	
	end
	
	
# METODO PARA traduzir o conteudo do campo booleano
	def tbol(msg)
		
		if msg == true
			return "SIM"
		else
			return "NÃO"
		end
		
		return msg
	end
	
	def Up(mg)
		ms = ms.upcase;
	end
	
	# metodo para dividir um total por um dado numero de parcelas
	def dParcela(tot,parc)
		return  moeda(tot / parc)
	end
	
end
