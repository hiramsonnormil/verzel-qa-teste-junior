// Helpers compartilhados pelos testes da Verzel Store.
const { expect } = require('@playwright/test');

const BASE = 'https://verzel-store.qa-test-verzel-store.workers.dev';

/** Adiciona um produto ao carrinho a partir da vitrine. */
async function adicionarProduto(page, nomeProduto, quantidade = 1) {
  const card = page.locator('.product-card, [data-testid^="product-"], article', { hasText: nomeProduto }).first();
  await expect(card, `card do produto "${nomeProduto}"`).toBeVisible({ timeout: 15000 });
  const btn = card.getByRole('button', { name: /adicionar|comprar|\+/i }).first();
  for (let i = 0; i < quantidade; i++) {
    await btn.click();
    await page.waitForTimeout(400);
  }
}

/** Abre o carrinho (drawer ou página). */
async function abrirCarrinho(page) {
  const cartBtn = page.getByRole('button', { name: /carrinho|sacola/i }).first();
  if (await cartBtn.isVisible().catch(() => false)) {
    await cartBtn.click();
  } else {
    const cartLink = page.getByRole('link', { name: /carrinho|sacola/i }).first();
    await cartLink.click();
  }
  await page.waitForTimeout(800);
}

/** Aplica um cupom no carrinho e retorna o texto de mensagem exibido. */
async function aplicarCupom(page, codigo) {
  const input = page.getByPlaceholder(/cupom/i).first();
  await expect(input, 'campo de cupom').toBeVisible({ timeout: 10000 });
  await input.fill(codigo);
  await page.getByRole('button', { name: /aplicar/i }).first().click();
  await page.waitForTimeout(1200);
  const msg = page.locator('[data-testid="coupon-message"], .coupon-message, [role="alert"]').first();
  return (await msg.isVisible().catch(() => false)) ? (await msg.innerText()).trim() : '';
}

/** Lê um valor monetário (ex: "R$ 239,70") de perto de um rótulo. */
async function lerValor(page, rotulo) {
  const linha = page.locator('*:not(script)', { hasText: new RegExp(rotulo, 'i') }).last();
  const texto = await linha.innerText().catch(() => '');
  const m = texto.match(/R\$\s?([\d.]+,\d{2})/);
  return m ? m[1] : texto.trim().slice(0, 60);
}

module.exports = { BASE, adicionarProduto, abrirCarrinho, aplicarCupom, lerValor, expect };
