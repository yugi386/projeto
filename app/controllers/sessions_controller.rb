require 'digest'	# biblioteca para tirar hash das senhas

class SessionsController < ApplicationController

	layout "pad2"

	def new
	end

  def create	# Cria na verdade uma sessão de login na area administrativa
	@user = Admloja.find(:first, :conditions => ['email = ? AND password = ?',params[:login],cifra_senha(params[:password])])
	if @user
		session[:logged] = true
		redirect_to "/clientes"
	else
		session[:logged] = false
		render :action => "new"
	end
  end

  def destroy
	session[:logged] = false
	render :action => "new"
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
