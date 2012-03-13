module LojaHelper

	# rotina para iniciar area administrativa da loja
	def IniciaArea
		@Lojaq = Admloja.all
		if @Lojaq.size != 1	# Se não houver exatamente um registro
			@loja = Admloja.all
			@loja.delete.all
			@Novo = Admloja.new
		else
			return
		end

		@Novo.nome = "MINI LOJA VIRTUAL"
		@Novo.cnpj = "33014556000196"
		@Novo.endereco = "Rua José Dias, 1024"
		@Novo.cidade = "São José dos Campos"
		@Novo.bairro = "Jd. Aquarius"
		@Novo.estado = "SP"
		@Novo.telefone = "1212341234"
		@Novo.fax = "1243214321"
		@Novo.cel = "1212345678"
		@Novo.email = "lojavirtual@modelo.com"
		@Novo.password = "c408e35f01f2ba4f4c3656f35a25d005e68f7801"	# senha
		@Novo.pagadm = 6
		@Novo.pagloja = 12
		@Novo.mcab = 1
		@Novo.maxsec = 0
		@Novo.maxdep = 0
		@Novo.upreco = 1
		@Novo.udesconto = 0
		@Novo.ufrete = 1
		@Novo.freefrete = 150
		@Novo.rodape = "<strong> ESTE É O RODAPÉ DA LOJA VIRTUAL </STRONG>"
		@Novo.cabecalho = '<div class="destaque"><center>Aproveite as promoções da Loja Virtual! <br>Todos os produtos foram cuidadosamente selecionados pra você!<br>Conforto, Segurança e Tecnologia, <br>agora você encontra aqui!!!<br></div>'
		@novo.cep = "123456"
		@novo.complemento = ""
		@novo.cpostal = ""
		@Novo.save
		return
	end	
	
end
