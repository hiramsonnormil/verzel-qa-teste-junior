# Resultado da execução — Entrega VZS-142

Data: 06/10/2026
Executor: Hiramson Normil
Ambiente: https://verzel-store.qa-test-verzel-store.workers.dev/

## 1. Execução via API (33 chamadas — evidências em `evidencias/api/`)

| # | Cenário | Esperado | Obtido | Status |
|---|---------|----------|--------|--------|
| CT01 | Cupom BEMVINDO10 em 139,90 + 2×49,90 | desc 23,97 / frete 0 / total 215,73 | idêntico | ✅ PASS |
| CT02 | Cupom "bemvindo10" (minúsculas) | aplica 10% | aplicado, total 73,81 | ✅ PASS |
| CT03 | Cupom "  BEMVINDO10  " (espaços) | aplica 10% | aplicado | ✅ PASS |
| CT04 | Cupom "FAKE123" no calcular | 200 + "Cupom inválido." | idêntico | ✅ PASS |
| CT05 | Cupom "VERAO2026" no calcular | 200 + "Cupom expirado." | idêntico | ✅ PASS |
| CT10 | Subtotal 59,90 | frete 19,90 + faltam 140,10 | idêntico | ✅ PASS |
| CT11 | Subtotal exato 200,00 | frete 0 | **frete 19,90** | ❌ FAIL (BUG-02) |
| CT12 | Subtotal 229,90 | frete 0 | idêntico | ✅ PASS |
| CT13 | Subtotal 219,80 + cupom (CA08) | frete 0, total 197,82 | idêntico | ✅ PASS |
| CT14 | 59,90 + cupom (CA09) | total 73,81 | idêntico | ✅ PASS |
| CT16 | 5 unidades | aceito | subtotal 299,50 | ✅ PASS |
| CT17 | 6 unidades no pedido | 422 QUANTIDADE_MAXIMA_EXCEDIDA | **201, pedido criado** | ❌ FAIL (BUG-01) |
| CT18a | Quantidade 0 | 422 QUANTIDADE_INVALIDA | idêntico | ✅ PASS |
| CT18b | Quantidade -2 | 422 QUANTIDADE_INVALIDA | idêntico | ✅ PASS |
| CT18c | Quantidade 1.5 | 422 QUANTIDADE_INVALIDA | idêntico | ✅ PASS |
| CT19 | Produto duplicado | 422 ITEM_DUPLICADO | idêntico | ✅ PASS |
| CT20 | Produto P999 | 422 PRODUTO_NAO_ENCONTRADO | idêntico | ✅ PASS |
| CT21 | Itens vazio | 422 ITENS_OBRIGATORIOS | idêntico | ✅ PASS |
| CT22 | Pedido válido + cupom | 201 VZ-000000, total 109,90 | VZ-872027, idêntico | ✅ PASS |
| CT23 | Pedido + cupom inválido | 422 CUPOM_INVALIDO | idêntico | ✅ PASS |
| CT24 | Pedido + cupom expirado | 422 CUPOM_EXPIRADO | idêntico | ✅ PASS |
| CT25 | Nome sem sobrenome | 422 DADOS_INVALIDOS | idêntico | ✅ PASS |
| CT26 | E-mail inválido | 422 DADOS_INVALIDOS | idêntico | ✅ PASS |
| CT27 | CEP 7 dígitos | 422 DADOS_INVALIDOS | idêntico | ✅ PASS |
| CT28 | CEP sem hífen | 201 | 201 (VZ-129804) | ✅ PASS |
| CT29 | GET /api/produtos/P999 | 404 PRODUTO_NAO_ENCONTRADO | idêntico | ✅ PASS |

**Resumo API:** 26 PASS, 2 FAIL (BUG-01 e BUG-02, detalhados em `bugs/report-bugs.md`).

### Bateria 2 — casos-limite e robustez (16 chamadas, 06/10/2026)

| # | Cenário | Esperado | Obtido | Status |
|---|---------|----------|--------|--------|
| calc-20 | Cupom `""` | 200, sem desconto, sem erro | idêntico (`cupom: null`) | ✅ PASS |
| calc-21 | Cupom `"   "` (só espaços) | 200, sem desconto | idêntico (trim → vazio) | ✅ PASS |
| calc-27 | Sem campo cupom | 200, sem desconto | idêntico | ✅ PASS |
| calc-22 | Quantidade `"2"` (texto) | 422 QUANTIDADE_INVALIDA | idêntico | ✅ PASS |
| calc-23 | Quantidade 999999 | 422 (teto de 5) | **200, subtotal R$ 59.899.940,10** | ❌ FAIL (BUG-01, sem teto) |
| calc-24 | Subtotal 189,80 | faltam 10,20 | idêntico | ✅ PASS |
| calc-26 | 3×49,90 + cupom (arredondamento) | total 154,63 | idêntico | ✅ PASS |
| calc-25 | Subtotal 200 + BEMVINDO10 (CA08) | frete 0 | **frete 19,90** | ❌ FAIL (BUG-02, mesma causa) |
| ped-11 | Corpo JSON inválido | 400 JSON_INVALIDO | idêntico | ✅ PASS |
| ped-12 | GET /api/pedidos | 405 METODO_NAO_PERMITIDO | idêntico | ✅ PASS |
| ped-13 | Campo extra no cliente | 201 (ignora extra) | VZ-963260 | ✅ PASS |
| ped-14 | CEP com letras | 422 DADOS_INVALIDOS | idêntico (detalhe por campo) | ✅ PASS |
| ped-15 | E-mail vazio | 422 DADOS_INVALIDOS | idêntico ("Informe o e-mail.") | ✅ PASS |
| ped-16 | Nome de 1 letra | 422 DADOS_INVALIDOS | idêntico ("Informe nome e sobrenome.") | ✅ PASS |
| prod-03 | GET /api/produtos | 8 produtos com schema completo | idêntico | ✅ PASS |

**Resumo bateria 2:** 14 PASS, 2 FAIL — ambos são manifestações dos bugs já
reportados (BUG-01 sem nenhum teto; BUG-02 também com cupom aplicado).
Nenhum bug novo encontrado.

## 2. Execução exploratória na interface (06/10/2026)

Percorrido no navegador: vitrine → carrinho → aplicação de cupom → checkout
(sem finalizar pedido e sem enviar formulário). Captura em `evidencias/ui/`.

| Passo | Observado | Status |
|---|---|---|
| Vitrine | Catálogo exibido; banner "Ambiente de teste técnico do processo seletivo de QA da Verzel" | ✅ PASS |
| Carrinho: 1x Calça Jeans Slim (R$ 139,90) + 2x Boné Aba Curva (R$ 49,90) | Subtotal R$ 239,70, frete grátis, total R$ 239,70; controles de quantidade (-/+) e "Remover" por item | ✅ PASS |
| Cupom BEMVINDO10 no carrinho | Mensagem "Cupom BEMVINDO10 aplicado"; desconto −R$ 23,97; total R$ 215,73 | ✅ PASS |
| Cupom FAKE123 no carrinho | Mensagem "Cupom inválido."; nenhum desconto; total R$ 239,70 | ✅ PASS |
| Tela de checkout | Formulário "Dados para entrega": Nome completo, E-mail, CEP (dica "Somente números ou no formato 00000-000"); texto "O pagamento é feito na entrega."; botão "Confirmar pedido" (não clicado) | ✅ PASS |

Nenhum pedido foi finalizado e nenhum formulário foi enviado na interface.

## 3. Automação Playwright

Suíte em `automacao/tests/` (9 testes, incluindo 1 marcado como falha conhecida —
BUG-02). Execução: ver `automacao/README.md`.
