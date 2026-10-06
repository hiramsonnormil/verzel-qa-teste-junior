// CT01/CT02/CT03/CT04 (cupom-desconto.feature) — aplicação de cupom no carrinho.
const { test } = require('@playwright/test');
const { BASE, adicionarProduto, abrirCarrinho, aplicarCupom, expect } = require('./helpers');

test.describe('Cupom de desconto', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(BASE, { waitUntil: 'networkidle' });
  });

  test('CT01: cupom válido BEMVINDO10 aplica 10% sobre o subtotal', async ({ page }) => {
    // 1x Calça Jeans Slim (139,90) + 2x Boné Aba Curva (49,90) = 239,70
    await adicionarProduto(page, 'Calça Jeans Slim', 1);
    await adicionarProduto(page, 'Boné Aba Curva', 2);
    await abrirCarrinho(page);

    const msg = await aplicarCupom(page, 'BEMVINDO10');
    expect(msg).toMatch(/cupom aplicado/i);

    await expect(page.getByText(/R\$\s?23,97/)).toBeVisible();   // desconto
    await expect(page.getByText(/R\$\s?215,73/)).toBeVisible();  // total = 239,70 - 23,97 + 0
  });

  test('CT02: cupom em minúsculas é aceito (CA02)', async ({ page }) => {
    await adicionarProduto(page, 'Camiseta Essencial', 1); // 59,90
    await abrirCarrinho(page);

    const msg = await aplicarCupom(page, 'bemvindo10');
    expect(msg).toMatch(/cupom aplicado/i);
    await expect(page.getByText(/R\$\s?5,99/)).toBeVisible();   // desconto
    await expect(page.getByText(/R\$\s?73,81/)).toBeVisible();   // total = 59,90 - 5,99 + 19,90
  });

  test('CT04: cupom inexistente exibe "Cupom inválido." (CA03)', async ({ page }) => {
    await adicionarProduto(page, 'Camiseta Essencial', 1);
    await abrirCarrinho(page);

    const msg = await aplicarCupom(page, 'FAKE123');
    expect(msg).toMatch(/cupom inválido/i);
    await expect(page.getByText(/R\$\s?79,80/)).toBeVisible();   // total sem desconto = 59,90 + 19,90
  });

  test('CT05: cupom expirado exibe "Cupom expirado." (CA04)', async ({ page }) => {
    await adicionarProduto(page, 'Camiseta Essencial', 1);
    await abrirCarrinho(page);

    const msg = await aplicarCupom(page, 'VERAO2026');
    expect(msg).toMatch(/cupom expirado/i);
    await expect(page.getByText(/R\$\s?79,80/)).toBeVisible();   // total sem desconto
  });
});
