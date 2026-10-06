# language: pt
# Cenários de teste — Limites do carrinho e regras de quantidade (entrega VZS-142)

Funcionalidade: Limites de quantidade e arredondamento
  Como cliente da Verzel Store
  Quero que o carrinho respeite o limite de unidades por produto
  Para que o pedido reflita as regras da loja

  @CA10
  Cenário: 5 unidades de um produto são permitidas
    Quando calculo o carrinho com 5 unidades de "Camiseta Essencial" (R$ 59,90)
    Então o cálculo é aceito
    E o subtotal é R$ 299,50

  @CA10 @bug
  Cenário: 6 unidades de um produto são rejeitadas pela API
    Quando envio um pedido com 6 unidades de "Camiseta Essencial"
    Então a API responde 422
    E o código do erro é "QUANTIDADE_MAXIMA_EXCEDIDA"
    # BUG-01: a API respondeu 201 e criou o pedido VZ-818117 com 6 unidades.

  Cenário: Quantidade zero é rejeitada
    Quando calculo o carrinho com quantidade 0
    Então a API responde 422
    E o código do erro é "QUANTIDADE_INVALIDA"

  Cenário: Quantidade negativa é rejeitada
    Quando calculo o carrinho com quantidade -2
    Então a API responde 422
    E o código do erro é "QUANTIDADE_INVALIDA"

  Cenário: Quantidade decimal é rejeitada
    Quando calculo o carrinho com quantidade 1.5
    Então a API responde 422
    E o código do erro é "QUANTIDADE_INVALIDA"

  Cenário: Produto duplicado na lista de itens é rejeitado
    Quando calculo o carrinho com o produto "P001" duas vezes na lista
    Então a API responde 422
    E o código do erro é "ITEM_DUPLICADO"

  Cenário: Produto inexistente é rejeitado
    Quando calculo o carrinho com o produto "P999"
    Então a API responde 422
    E o código do erro é "PRODUTO_NAO_ENCONTRADO"

  Cenário: Lista de itens vazia é rejeitada
    Quando calculo o carrinho sem itens
    Então a API responde 422
    E o código do erro é "ITENS_OBRIGATORIOS"

  @CA11
  Cenário: Valores são arredondados para 2 casas decimais
    Dado que o carrinho tem 1 unidade de "Calça Jeans Slim" (R$ 139,90)
    E tem 2 unidades de "Boné Aba Curva" (R$ 49,90)
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 23,97
    E o total é R$ 215,73
