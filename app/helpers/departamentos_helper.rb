module DepartamentosHelper
	
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
	
	
end
