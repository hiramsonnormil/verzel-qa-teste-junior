// CT10/CT12/CT13 (frete-gratis.feature) — regra de frete grátis.
const { test } = require('@playwright/test');
const { BASE, adicionarProduto, abrirCarrinho, aplicarCupom, expect } = require('./helpers');

test.describe('Frete grátis', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(BASE, { waitUntil: 'networkidle' });
  });

  test('CT10: subtotal abaixo de R$ 200 cobra frete fixo e informa o faltante (CA07)', async ({ page }) => {
    await adicionarProduto(page, 'Camiseta Essencial', 1); // 59,90
    await abrirCarrinho(page);

    await expect(page.getByText(/R\$\s?19,90/)).toBeVisible();   // frete fixo
    await expect(page.getByText(/140,10/)).toBeVisible();        // faltam R$ 140,10
    await expect(page.getByText(/R\$\s?79,80/)).toBeVisible();   // total
  });

  test('CT12: subtotal acima de R$ 200 ganha frete grátis (CA06)', async ({ page }) => {
    await adicionarProduto(page, 'Jaqueta Corta-Vento', 1); // 229,90
    await abrirCarrinho(page);

    await expect(page.getByText(/R\$\s?0,00/)).toBeVisible();   // frete grátis
    await expect(page.getByText(/R\$\s?229,90/)).toBeVisible();  // total = subtotal
  });

  test('CT13: frete grátis considera o subtotal antes do desconto (CA08)', async ({ page }) => {
    // 189,90 + 29,90 = 219,80; com 10% => 197,82 (< 200), mas o frete segue grátis
    await adicionarProduto(page, 'Tênis Casual Urbano', 1);
    await adicionarProduto(page, 'Kit 3 Pares de Meias', 1);
    await abrirCarrinho(page);
    await aplicarCupom(page, 'BEMVINDO10');

    await expect(page.getByText(/R\$\s?21,98/)).toBeVisible();   // desconto
    await expect(page.getByText(/R\$\s?0,00/)).toBeVisible();    // frete grátis
    await expect(page.getByText(/R\$\s?197,82/)).toBeVisible();  // total
  });

  // BUG-02 documentado: no limite exato de R$ 200,00 a API cobra frete.
  // Mantido como falha esperada até a correção (CA06: "a partir de R$ 200,00, inclusive").
  test.fail('CT11: subtotal exatamente R$ 200,00 ganha frete grátis [BUG-02]', async ({ page }) => {
    await adicionarProduto(page, 'Mochila Urbana 20L', 2); // 2x 100,00 = 200,00
    await abrirCarrinho(page);

    await expect(page.getByText(/R\$\s?0,00/)).toBeVisible();   // frete grátis
    await expect(page.getByText(/R\$\s?200,00/)).toBeVisible();  // total = subtotal
  });
});
