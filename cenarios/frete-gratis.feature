# language: pt
# Cenários de teste — Frete grátis (entrega VZS-142)

Funcionalidade: Frete grátis
  Como cliente da Verzel Store
  Quero ganhar frete grátis em compras maiores
  Para pagar menos nas minhas compras

  Contexto:
    Dado que estou com o carrinho aberto na Verzel Store

  @CA07
  Cenário: Subtotal abaixo de R$ 200,00 cobra frete fixo e informa o faltante
    Dado que o carrinho tem 1 unidade de "Camiseta Essencial" (R$ 59,90)
    Então o subtotal é R$ 59,90
    E o frete é R$ 19,90
    E o carrinho informa que faltam R$ 140,10 para o frete grátis
    E o total é R$ 79,80

  @CA06 @limite @bug
  Cenário: Subtotal exatamente R$ 200,00 ganha frete grátis
    Dado que o carrinho tem 2 unidades de "Mochila Urbana 20L" (R$ 100,00)
    Então o subtotal é R$ 200,00
    E o frete é R$ 0,00
    E o valor faltante para o frete grátis é R$ 0,00
    # BUG-02: a API retornou frete R$ 19,90 com freteGratis=false para subtotal
    # exatamente R$ 200,00 (CA06 diz "a partir de R$ 200,00, inclusive").
    # Além disso o valor faltante veio 0, ou seja, o carrinho diria ao cliente
    # que não falta nada para o frete grátis enquanto cobra o frete.

  @CA06
  Cenário: Subtotal acima de R$ 200,00 ganha frete grátis
    Dado que o carrinho tem 1 unidade de "Jaqueta Corta-Vento" (R$ 229,90)
    Então o subtotal é R$ 229,90
    E o frete é R$ 0,00
    E o total é R$ 229,90

  @CA08 @critico
  Cenário: Frete grátis considera o subtotal antes do desconto do cupom
    Dado que o carrinho tem 1 unidade de "Tênis Casual Urbano" (R$ 189,90)
    E tem 1 unidade de "Kit 3 Pares de Meias" (R$ 29,90)
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal é R$ 219,80
    E o desconto é R$ 21,98
    E o frete é R$ 0,00
    E o total é R$ 197,82

  @CA09 @critico
  Cenário: Desconto do cupom não incide sobre o frete
    Dado que o carrinho tem 1 unidade de "Camiseta Essencial" (R$ 59,90)
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto é R$ 5,99
    E o frete é R$ 19,90
    E o total é R$ 73,81
