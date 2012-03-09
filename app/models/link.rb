class Link < ActiveRecord::Base
	default_scope order('upper(texto) ASC') 	# ordem de listagem dos links

	# ROTINAS DE VALIDACAO DE DADOS:

	# ValidaCAO do texto do link:
	validates_presence_of  :texto, :message => "do Link deve ser preenchido!"

	# Verifica se o produto esta cadastrado considerando maiusculas e minusculas como iguais...
	validates_uniqueness_of :texto, :case_sensitive => false,  :message => "do link ja esta cadastrado!"  
	
	# Rotina para UPLOAD de imagens com PAPERCLIP PLUGIN...
	has_attached_file :arquivo    # para especificar outro path use == :path => ":rails_root/public/images/departamentos/:filename"
	
end
