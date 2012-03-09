module VperiodosHelper

	def CalculaVendas
		tot = 0
		@vendas.each do |f|
			tot = tot + f.valor
		end
		return tot
	end

end
