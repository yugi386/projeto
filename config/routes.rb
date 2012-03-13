Projeto::Application.routes.draw do

  get "sessions/new"

  get "sessions/create"

  get "sessions/destroy"

	# PARA EVITAR PROBLEMAS DE ROTAS EM OPERAÇÕES CRUD USE A SEGUINTE CONVENÇÃO:
	# modelo = nome singular
	# Tabela = nome pural do modelo
	# Controlador = mesmo nome da tabela (plural)

	# ROTAS CLIENTES
	resources :clientes

	match 'clientes/:id' => 'clientes#show'		# Exemplo de rota mapeada pelo controler e pela ID do registro...
	
	# ROTAS DEPARTAMENTOS
	resources :departamentos
	match 'departamentos/:id' => 'departamentos#show'		# Exemplo de rota mapeada pelo controler e pela ID do registro...
	
	# ROTAS SEÇÕES
	resources :section
	match 'section/:id' => 'section#show'		
	
	# ROTAS PRODUTOS
	resources :produts
	match 'produts/:id' => 'produts#show'		
	match 'produts/:nome' => 'produts#index'		
	
	# ROTAS ESTOQUE:
	resources :estoque
	match 'estoque/:id' => 'estoque#show'		
	
	# ROTAS LOJA:
	resources :loja
	match 'loja/:id' => 'loja#show'		

	# ROTAS ADMLOJA:
	resources :admlojas
	match 'admlojas/:id' => 'admlojas#show'		
	
	# ROTAS PARA CONTROLE DE SESSÃO (login do administrador)
	resource :sessions
	match 'login' => 'sessions#new'		
	match 'logout' => 'sessions#destroy'		
	
	# ROTAS PARA CONTROLE DO CARRINHO DE COMPRAS
	resources :compras
	match 'retirar/:id' => 'compras#retirar'		
	match 'limparcarrinho' => 'compras#limpar'		
	match 'altera' => 'compras#alterar'		

	# ROTAS PARA CONTROLE DE SESSÃO (login do cliente)
	resource :clogins
	match 'cliente_login' => 'clogins#new'		
	match 'cliente_logout' => 'clogins#destroy'		
	match 'alterar' => 'vendas#alterar'
	match 'retirar2/:id' => 'vendas#retirar'		
	match 'limparcarrinho2' => 'vendas#limpar'			

	# ROTAS PARA CONTROLE DE vendas...
	resources :vendas
	match 'finalizar' => 'vendas#finalizar'			
	match 'retornar' => 'vendas#index'				
	match 'vendas_listar' => 'vendas#listar'				
	match 'vendas/ver/:id' => 'vendas#show'				
	match 'vendas_listar_fechar/:id' => 'vendas#fechar'				
	match 'vendas_listar_abrir/:id' => 'vendas#abrir'				
	
	# ROTAS PARA CONTROLE DE PEDIDOS (VENDAS EM ABERTO)
	resources :pedidos
	match 'pedidos/:id' => 'pedidos#show'		
	match 'pedidos/cancel/:id' => 'pedidos#CancelarPedido'		
	
	# ROTAS PARA CONTROLE DE CADASTRO DE CLIENTE
	match 'cadastro' => 'clientes#new'		
	match 'cadclientes/new' => 'clientes#new'		# Exemplo de rota mapeada pelo controler e pela ID do registro...
	
	# ROTAS DE GERENCIAMENTO DE VENDAS:
	resources :vperiodos
	match 'vperiodos/:id' => 'vperiodos#show'		
	match 'vperiodos/cancel/:id' => 'vperiodos#ExcluirVenda'		
	
	# rotas para links
	resources :links
	match 'links/:id' => 'links#show'		# Exemplo de rota mapeada pelo controler e pela ID do registro...
	
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
