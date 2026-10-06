# Teste técnico QA Júnior — Verzel Store (entrega VZS-142)

Validação da entrega **cupom de desconto + frete grátis** na loja fictícia
[Verzel Store](https://verzel-store.qa-test-verzel-store.workers.dev/),
conforme a [documentação da entrega](https://verzel-store.qa-test-verzel-store.workers.dev/documentacao)
(card VZS-142, versão 2.3.0).

## Onde está cada entrega

| Entrega pedida | Local neste repositório |
|---|---|
| Cenários de teste (Gherkin) | `cenarios/` — 5 arquivos `.feature`, 30 cenários mapeados aos critérios CA01–CA11 |
| Execução manual e exploratória | `execucao/resultado-execucao.md` — resultado por cenário |
| Report de bugs | `bugs/report-bugs.md` — 2 bugs com severidade, passos, esperado × obtido |
| Evidências | `evidencias/api/` (respostas JSON) e `evidencias/ui/` (capturas de tela) |
| Automação Playwright (≥ 3 cenários) | `automacao/tests/` — 9 testes E2E |
| Relatório visual da execução | `relatorio/relatorio.pdf` — relatório em PDF com KPIs, gráfico, bugs, tabelas de cenários e captura de tela |
| Este README | aqui |

## Como rodar a automação

Pré-requisitos: Node.js 18+.

```bash
cd automacao
npm install
npx playwright install chromium   # baixa o navegador (só na primeira vez)
npm test                          # roda todos os testes (headless)
```

Outros comandos:

```bash
npm run test:headed   # roda com o navegador visível
npm run report        # abre o relatório HTML da última execução
```

A suíte cobre: aplicação de cupom válido/inválido/expirado, regra de frete
grátis (incluindo o cálculo sobre o subtotal antes do desconto) e o fechamento
do pedido com cupom. Um teste está marcado como falha conhecida (`test.fail`):
o **BUG-02** — frete grátis não aplicado no limite exato de R$ 200,00.

## Bugs encontrados

- **BUG-01 (alta):** `POST /api/pedidos` aceita 6 unidades do mesmo produto
  (HTTP 201, pedido criado) — viola o CA10 (máximo 5, valendo para a API).
- **BUG-02 (média):** subtotal exatamente R$ 200,00 cobra frete de R$ 19,90 —
  viola o CA06 ("a partir de R$ 200,00, inclusive"); o campo de valor faltante
  ainda retorna 0, contradizendo a cobrança.

Detalhes em `bugs/report-bugs.md`.

## Observações

- Os comportamentos descritos em "Sobre este ambiente" na documentação
  (carrinho por aba, pedidos não armazenados, sem e-mail/cobrança, API stateless)
  foram tratados como esperados e não reportados como bugs.
- Fora de escopo (conforme as regras): testes de carga, estresse e segurança.
