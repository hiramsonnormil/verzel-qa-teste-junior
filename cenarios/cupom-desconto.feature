# language: pt
# Cenários de teste — Entrega VZS-142 (cupom de desconto + frete grátis)
# Base: documentação em /documentacao (versão 2.3.0, publicada em 30/09/2026)
# Convenções de valores: subtotal em R$, desconto = 10% do subtotal (cupom BEMVINDO10),
# frete = R$ 0,00 se subtotal >= 200,00 senão R$ 19,90; total = subtotal - desconto + frete.

Funcionalidade: Cupom de desconto
  Como cliente da Verzel Store
  Quero aplicar um cupom de desconto no carrinho
  Para pagar menos nas minhas compras

  Contexto:
    Dado que estou com o carrinho aberto na Verzel Store

  @CA01 @critico
  Cenário: Aplicar cupom válido BEMVINDO10
    Dado que o carrinho tem 1 unidade de "Calça Jeans Slim" (R$ 139,90)
    E tem 2 unidades de "Boné Aba Curva" (R$ 49,90)
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal é R$ 239,70
    E o desconto é R$ 23,97
    E o frete é R$ 0,00
    E o total é R$ 215,73
    E vejo a mensagem "Cupom aplicado: 10% de desconto nos produtos."

  @CA02
  Cenário: Cupom em letras minúsculas é aceito
    Dado que o carrinho tem 1 unidade de "Camiseta Essencial" (R$ 59,90)
    Quando aplico o cupom "bemvindo10"
    Então o desconto de 10% é aplicado
    E o total é R$ 73,81

  @CA02
  Cenário: Cupom com espaços no início e no fim é aceito
    Dado que o carrinho tem 1 unidade de "Camiseta Essencial" (R$ 59,90)
    Quando aplico o cupom "  BEMVINDO10  "
    Então o desconto de 10% é aplicado

  @CA03
  Cenário: Cupom inexistente
    Dado que o carrinho tem 1 unidade de "Camiseta Essencial" (R$ 59,90)
    Quando aplico o cupom "FAKE123"
    Então vejo a mensagem "Cupom inválido."
    E nenhum desconto é aplicado
    E o total é R$ 79,80

  @CA04
  Cenário: Cupom expirado
    Dado que o carrinho tem 1 unidade de "Camiseta Essencial" (R$ 59,90)
    Quando aplico o cupom "VERAO2026"
    Então vejo a mensagem "Cupom expirado."
    E nenhum desconto é aplicado
    E o total é R$ 79,80

  @CA05
  Cenário: Apenas um cupom por vez
    Dado que o cupom "BEMVINDO10" já está aplicado no carrinho
    Quando tento aplicar outro cupom
    Então o sistema mantém apenas um cupom aplicado
    E para trocar preciso remover o cupom atual antes

  @CA05
  Cenário: Remover cupom e aplicar outro
    Dado que o cupom "BEMVINDO10" está aplicado no carrinho
    Quando removo o cupom atual
    E aplico o cupom "BEMVINDO10" novamente
    Então o desconto volta a ser aplicado corretamente

  Cenário: Pedido via API com cupom inexistente é rejeitado
    Quando envio um pedido com o cupom "FAKE123"
    Então a API responde 422
    E o código do erro é "CUPOM_INVALIDO"
    E a mensagem é "Cupom inválido."

  Cenário: Pedido via API com cupom expirado é rejeitado
    Quando envio um pedido com o cupom "VERAO2026"
    Então a API responde 422
    E o código do erro é "CUPOM_EXPIRADO"
    E a mensagem é "Cupom expirado."
