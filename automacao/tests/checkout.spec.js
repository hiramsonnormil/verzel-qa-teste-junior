// CT22 (checkout.feature) — fechamento do pedido com dados reais do candidato.
const { test } = require('@playwright/test');
const { BASE, adicionarProduto, abrirCarrinho, aplicarCupom, expect } = require('./helpers');

test.describe('Checkout', () => {
  test('CT22: pedido válido com cupom gera número do pedido', async ({ page }) => {
    await page.goto(BASE, { waitUntil: 'networkidle' });
    await adicionarProduto(page, 'Mochila Urbana 20L', 1); // 100,00
    await abrirCarrinho(page);
    await aplicarCupom(page, 'BEMVINDO10');

    // Vai para o checkout
    const checkoutBtn = page.getByRole('button', { name: /finalizar|checkout|fechar pedido/i }).first();
    await checkoutBtn.click();
    await page.waitForTimeout(1000);

    // Preenche os dados do cliente
    await page.getByLabel(/nome/i).first().fill('Hiramson Normil');
    await page.getByLabel(/e-mail|email/i).first().fill('hiramsonnormil00@gmail.com');
    await page.getByLabel(/cep/i).first().fill('01310-100');

    await page.getByRole('button', { name: /confirmar|finalizar|enviar pedido/i }).first().click();
    await page.waitForTimeout(2000);

    // Confirmação: número do pedido no formato VZ-000000
    await expect(page.getByText(/VZ-\d{6}/)).toBeVisible({ timeout: 15000 });
    await expect(page.getByText(/R\$\s?109,90/)).toBeVisible(); // total = 100 - 10 + 19,90
  });
});
