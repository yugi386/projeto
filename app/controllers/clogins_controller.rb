require 'digest'	# biblioteca para tirar hash das senhas

class CloginsController < ApplicationController
	layout "loja"

	def new
  		# Mapeando Departamentos e Seções ativas
		@secoes = Section.where("ativo = 't'")
		@departamentos = Departamento.where("ativo = 't'")
	end

  def create	# Cria na verdade uma sessão de login na area dos clientes
	@clogin = Cliente.find(:first, :conditions => ['email = ? AND password = ?',params[:login],cifra_senha(params[:password])])

	if @clogin != nil
		session[:logcli] = @clogin.id
		redirect_to "/loja"
	else
		session[:logcli] = 0
		redirect_to "/cliente_login"
	end
  end

  def destroy
	session[:logcli] = 0
	redirect_to "/loja"
  end
  
    def cifra_senha(xsenha)
		if xsenha == nil
			return nil
		end
		if xsenha.size != 0
			xsenha = Digest::SHA1.hexdigest("a74hdc63" + xsenha + "dh46vhf86g")
		end
		return xsenha
	end

end 
