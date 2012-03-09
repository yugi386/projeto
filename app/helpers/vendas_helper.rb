module VendasHelper

	# Calculando o frete
	def calculafrete(carro,modopag)	# modopag = 1 = vista , 2 = prazo
		# verifica se o frete está ignorado pelo administrador.
		if Admloja.first.ufrete == 0
			return 0
		end
		
		# distingue pessoa fisica ou juridica
		if Cliente.find(session[:logcli]).pessoa == "F"
			estado = Cliente.find(session[:logcli]).estado
		else
			estado = Cliente.find(session[:logcli]).estado2
		end
		
		tam = carro.size - 1
		frete = 0	# Valor Inicial
		compras = 0
		for ct in (0..tam)
			frete = frete + locUF(estado,carro[ct])
		end

		if modopag == 1
			compras = totalVista($CarrinhoCompras,$CarrinhoComprasQuant)		
		else
			compras = totalPrazo($CarrinhoCompras,$CarrinhoComprasQuant)		
		end	
		
		if compras >= Admloja.first.freefrete 
			return 0
		else
			return frete
		end
	end

	# devolve o valor do frete de acordo com o estado do cliente
	def locUF(uf,prod)

		if "RS-PR-SC".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fsul
		elsif "MG-SP-RJ-ES".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fsudeste
		elsif "DF-GO-MG-MS".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fcentro
		elsif "AL-BA-CE-MA-PB-PE-PI-RN-SE".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fnordeste
		elsif "AC-AP-AM-PA-RO-RR-TO".include? uf.upcase	# verifica se uma string contem outra
			return Produt.find(prod).fnorte
		end
	end

	# VERIFICA O NUMERO MAXIMO DE PARCELAS PARA CADA PRODUTO...	
	def Veparcela
		tam = $CarrinhoCompras.size - 1
		parc = 0
		for ct in (0..tam)
			if parc < Produt.find($CarrinhoCompras[ct]).parcelas
				parc = Produt.find($CarrinhoCompras[ct]).parcelas
			end	
		end
		
		return parc
	end
	
	# calcula o total das compras a vista
	def totalVista(cp,quant)
		reg = cp.size - 1
		ret = 0
		for ct in (0..reg)
			ret = ret + (desconto(Produt.find(cp[ct]).vista, Produt.find(cp[ct]).id) * quant[ct])
		end
		return ret
	end
	
	# calcula o total das compras a prazo
	def totalPrazo(cp,quant)
		reg = cp.size - 1
		ret = 0
		for ct in (0..reg)
			ret = ret + (desconto(Produt.find(cp[ct]).prazo, Produt.find(cp[ct]).id) * quant[ct])
		end
		return ret
	end

	# Apaga todos os itens do carrinho
	def limpar
		for ct in (0..($CarrinhoCompras.size - 1))
			$CarrinhoCompras[ct] = ""
		end
		for ct in (0..($CarrinhoComprasQuant.size - 1))
			$CarrinhoComprasQuant[ct] = 0
		end
		
			$CarrinhoCompras.delete("")		# APAGANDO ITENS DO CARRINHO
			$CarrinhoComprasQuant.delete(0)		# APAGANDO Quantidade referente a item

	end
	
	
end
