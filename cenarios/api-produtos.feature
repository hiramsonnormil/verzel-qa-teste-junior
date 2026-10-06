# language: pt
# Cenários de teste — API de produtos (leitura)

Funcionalidade: Consulta de produtos via API
  Como cliente da Verzel Store
  Quero consultar os produtos pela API
  Para ver preços e detalhes atualizados

  Cenário: Listar todos os produtos
    Quando consulto GET /api/produtos
    Então a API responde 200
    E a lista contém os 8 produtos com id, nome e preço

  Cenário: Consultar produto existente
    Quando consulto GET /api/produtos/P001
    Então a API responde 200
    E o produto é "Camiseta Essencial" com preço 59.9

  Cenário: Consultar produto inexistente
    Quando consulto GET /api/produtos/P999
    Então a API responde 404
    E o código do erro é "PRODUTO_NAO_ENCONTRADO"
