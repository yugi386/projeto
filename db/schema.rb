# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120304020514) do

  create_table "admlojas", :force => true do |t|
    t.string   "nome"
    t.string   "cnpj"
    t.string   "endereco"
    t.string   "cidade"
    t.string   "bairro"
    t.string   "estado"
    t.string   "complemento"
    t.string   "cpostal"
    t.string   "cep"
    t.string   "tel"
    t.string   "fax"
    t.string   "cel"
    t.string   "email"
    t.string   "password"
    t.integer  "pagadm"
    t.integer  "pagloja"
    t.integer  "mcab"
    t.integer  "maxdep"
    t.integer  "maxsec"
    t.integer  "upreco"
    t.integer  "udesconto"
    t.integer  "ufrete"
    t.integer  "freefrete"
    t.text     "obs"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "rodape"
    t.text     "cabecalho"
  end

  create_table "clientes", :force => true do |t|
    t.string   "nome"
    t.date     "data_nasc"
    t.string   "sexo"
    t.string   "cpf"
    t.string   "rg"
    t.string   "endereco"
    t.string   "cidade"
    t.string   "estado"
    t.string   "cep"
    t.string   "tel"
    t.string   "cel"
    t.string   "email"
    t.text     "obs"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "pessoa"
    t.string   "cnpj"
    t.string   "complemento"
    t.string   "cpostal"
    t.string   "endereco2"
    t.string   "cidade2"
    t.string   "estado2"
    t.string   "cep2"
    t.string   "telefone2"
    t.string   "celular2"
    t.string   "complemento2"
    t.string   "cpostal2"
    t.string   "password"
    t.string   "contato"
    t.string   "bairro1"
    t.string   "bairro2"
  end

  create_table "departamentos", :force => true do |t|
    t.string   "nome"
    t.text     "descricao"
    t.boolean  "ativo"
    t.integer  "destaque"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "arquivo_file_name"
  end

  create_table "items", :force => true do |t|
    t.integer  "venda_id"
    t.integer  "idprod"
    t.float    "valor"
    t.integer  "quant"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "texto"
    t.string   "arquivo_file_name"
    t.boolean  "ativo"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "produts", :force => true do |t|
    t.string   "nome"
    t.date     "data"
    t.integer  "departamento_id"
    t.integer  "section_id"
    t.string   "modelo"
    t.string   "unidade"
    t.float    "custo"
    t.float    "prazo"
    t.float    "vista"
    t.float    "desconto"
    t.float    "fnorte"
    t.float    "fnordeste"
    t.float    "fsul"
    t.float    "fsudeste"
    t.float    "fcentro"
    t.string   "arquivo_file_name"
    t.integer  "destaque"
    t.boolean  "ativo"
    t.text     "descricao"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "codigo"
    t.integer  "quant"
    t.integer  "parcelas"
    t.integer  "entrada"
    t.integer  "baixa"
    t.datetime "dataentrada"
    t.datetime "databaixa"
    t.integer  "saida"
    t.datetime "datasaida"
    t.boolean  "preco_oculto"
    t.boolean  "verif"
  end

  create_table "sections", :force => true do |t|
    t.string   "nome"
    t.text     "descricao"
    t.boolean  "ativo"
    t.integer  "destaque"
    t.string   "arquivo_file_name"
    t.integer  "departamento_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "vendas", :force => true do |t|
    t.date     "data"
    t.integer  "cliente"
    t.float    "valor"
    t.integer  "itens"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.float    "frete"
    t.integer  "parcelas"
    t.string   "dadoscartao"
    t.string   "tipopag"
    t.string   "cliente_nome"
  end

end
