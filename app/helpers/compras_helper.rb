module ComprasHelper
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
	
end
