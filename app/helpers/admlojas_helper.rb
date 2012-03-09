module AdmlojasHelper

	def ePreco(num)	# formata exibicao da opcao de configuracao de preco
		
		if num == 0
			return "Não Mostrar Preço"
		elsif	num == 1
			return "Mostrar Preço à Vista"
		elsif	num == 2
			return "Mostrar Preço à Prazo"			
		else
			return ""
		end
	end
	
	def eDesconto(num)	# formata exibicao da opcao de configuracao de desconto
		
		if num == 0
			return "Ignorar Desconto"
		elsif	num == 1
			return "Considerar Desconto para Preço à Vista"
		elsif	num == 2
			return "Considerar Desconto para Preço à Prazo"
		else
			return ""
		end
	end
	
	def eFrete(num)	# formata exibicao da opcao de configuracao de frete
		
		if num == 0
			return "Ignorar Frete"
		elsif	num == 1
			return "Considerar Frete"
		else
			return ""
		end
	end
	
	def eCab(num)	# formata exibicao da opcao de configuracao do cabecalho
		
		if num == 0
			return "Mostrar Cabeçalho em todas as Páginas"
		elsif	num == 1
			return "Mostrar Cabeçalho somente na Página Principal"
		else
			return ""
		end
	end
	
end
