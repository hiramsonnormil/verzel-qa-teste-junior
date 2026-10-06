# language: pt
# Cenários de teste — Checkout / fechamento do pedido (regras pré-existentes + entrega VZS-142)

Funcionalidade: Fechamento do pedido
  Como cliente da Verzel Store
  Quero finalizar minha compra informando meus dados
  Para receber o pedido com pagamento na entrega

  Contexto:
    Dado que estou com o carrinho aberto na Verzel Store
    E o carrinho tem 1 unidade de "Mochila Urbana 20L" (R$ 100,00)

  Cenário: Pedido válido com cupom gera número do pedido
    Quando finalizo o pedido com nome "Hiramson Normil", e-mail "hiramsonnormil00@gmail.com",
      CEP "01310-100" e cupom "BEMVINDO10"
    Então a API responde 201
    E recebo um número de pedido no formato "VZ-000000"
    E o resumo traz subtotal R$ 100,00, desconto R$ 10,00,
      frete R$ 19,90 e total R$ 109,90

  Cenário: Nome sem sobrenome é rejeitado
    Quando finalizo o pedido com nome "Maria"
    Então a API responde 422
    E o código do erro é "DADOS_INVALIDOS"

  Cenário: E-mail em formato inválido é rejeitado
    Quando finalizo o pedido com e-mail "maria@"
    Então a API responde 422
    E o código do erro é "DADOS_INVALIDOS"

  Cenário: CEP com 7 dígitos é rejeitado
    Quando finalizo o pedido com CEP "01310-10"
    Então a API responde 422
    E o código do erro é "DADOS_INVALIDOS"

  Cenário: CEP sem hífen é aceito
    Quando finalizo o pedido com CEP "01310100"
    Então a API responde 201
