require('dotenv').config();
const pool = require('./db');
const express = require('express');
const app = express();

app.get('/health', (req, res) => {
  res.json({ ok: true });
});

app.get('/vendas/por-estado', async (req, res) => {
  const resultado = await pool.query(`
    WITH vendas_por_categoria AS (
      SELECT customers.customer_state AS estado,
             products.product_category_name AS categoria,
             COUNT(*) AS unidades
      FROM order_items
      JOIN products ON products.product_id = order_items.product_id
      JOIN orders ON orders.order_id = order_items.order_id
      JOIN customers ON customers.customer_id = orders.customer_id
      GROUP BY customers.customer_state, products.product_category_name
    )
    SELECT vendas.estado,
           SUM(vendas.unidades) AS unidades_vendidas,
           (
             SELECT busca.categoria
             FROM vendas_por_categoria AS busca
             WHERE busca.estado = vendas.estado
               AND busca.categoria IS NOT NULL
             ORDER BY busca.unidades DESC, busca.categoria
             LIMIT 1
           ) AS categoria_mais_vendida
    FROM vendas_por_categoria AS vendas
    GROUP BY vendas.estado
    ORDER BY unidades_vendidas DESC, vendas.estado;
  `);

  res.json(resultado.rows);
});

app.listen(3000);