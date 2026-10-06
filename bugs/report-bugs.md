# Report de bugs — Entrega VZS-142 (cupom de desconto + frete grátis)

Data da execução: 06/10/2026
Ambiente: https://verzel-store.qa-test-verzel-store.workers.dev/ (API + interface)
Documentação: /documentacao — card VZS-142, versão 2.3.0

> Os comportamentos listados em "Sobre este ambiente" na documentação
> (carrinho por aba, pedidos não armazenados, sem e-mail/cobrança, dados fixos,
> API stateless) foram tratados como esperados e NÃO estão aqui.

---

## BUG-01 — API aceita mais de 5 unidades por produto no pedido
**Severidade:** Alta

**Critério violado:** CA10 — "Cada produto pode ter no máximo 5 unidades por pedido.
A regra vale para a interface e para a API."

**Passos:**
1. Enviar `POST /api/pedidos` com:
   ```json
   {
     "cliente": { "nome": "Hiramson Normil", "email": "hiramsonnormil00@gmail.com", "cep": "01310-100" },
     "itens": [{ "produtoId": "P001", "quantidade": 6 }]
   }
   ```

**Resultado esperado:** HTTP 422 com código `QUANTIDADE_MAXIMA_EXCEDIDA`.

**Resultado obtido:** HTTP 201 — pedido criado (`VZ-931714`) com 6 unidades de
"Camiseta Essencial", subtotal R$ 359,40.

**Observação:** `POST /api/carrinho/calcular` com quantidade 6 também retornou 200
com o cálculo feito, sem erro. A validação existe para quantidade 0, negativa e
decimal (422 `QUANTIDADE_INVALIDA`), mas o teto de 5 unidades não é aplicado.

**Evidência:** `evidencias/api/bug-01-ped-08-qtd-6.json`

---

## BUG-02 — Frete grátis não aplicado no limite exato de R$ 200,00
**Severidade:** Média

**Critério violado:** CA06 — "O frete é grátis para compras com subtotal
a partir de R$ 200,00, inclusive."

**Passos:**
1. Enviar `POST /api/carrinho/calcular` com:
   ```json
   { "itens": [{ "produtoId": "P005", "quantidade": 2 }] }
   ```
   (2 × R$ 100,00 = subtotal exatamente R$ 200,00)

**Resultado esperado:** `frete: 0`, `freteGratis: true`.

**Resultado obtido:** `frete: 19.9`, `freteGratis: false`, `total: 219.9`.

**Agravante (contradição visível ao cliente):** o campo `valorFaltanteFreteGratis`
veio `0` — ou seja, a interface diria ao cliente que "não falta nada para o frete
grátis" enquanto cobra R$ 19,90 de frete. Indica comparação estrita (`>`) onde a
regra exige `>=`.

**Evidência:** `evidencias/api/bug-02-calc-08-exato-200.json`

---

## Cenários executados sem defeito (resumo)

| Cenário | Resultado |
|---------|-----------|
| Cupom válido BEMVINDO10 aplica 10% (CA01) | OK — desconto R$ 23,97 em subtotal R$ 239,70 |
| Cupom case-insensitive + trim de espaços (CA02) | OK |
| Cupom inexistente → "Cupom inválido." (CA03) | OK (calcular: 200 sem desconto; pedidos: 422 `CUPOM_INVALIDO`) |
| Cupom expirado → "Cupom expirado." (CA04) | OK (calcular: 200 sem desconto; pedidos: 422 `CUPOM_EXPIRADO`) |
| Frete < R$ 200 → R$ 19,90 + faltante (CA07) | OK — faltante R$ 140,10 p/ subtotal R$ 59,90 |
| Frete grátis > R$ 200 (CA06) | OK — subtotal R$ 229,90 → frete 0 |
| Frete considera subtotal antes do desconto (CA08) | OK — subtotal R$ 219,80 → frete 0 mesmo com total R$ 197,82 |
| Desconto não incide sobre o frete (CA09) | OK — total R$ 73,81 = 59,90 − 5,99 + 19,90 |
| Arredondamento 2 casas (CA11) | OK nos casos observados |
| Validações de cliente (nome, e-mail, CEP) | OK — 422 `DADOS_INVALIDOS`; CEP sem hífen aceito |
| Erros de itens (vazio, duplicado, inexistente, qtd inválida) | OK — códigos e mensagens conforme a doc |
| GET produto inexistente → 404 `PRODUTO_NAO_ENCONTRADO` | OK |

Testes de interface (carrinho, aplicação de cupom na UI, checkout visual e
evidências em captura de tela): em andamento — ver `execucao/resultado-execucao.md`.
