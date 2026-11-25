
SELECT COUNT(*) AS total
FROM customers
WHERE customer_state = 'SP';
-- resultado: 41746 clientes (cerca de 42% do total)

-- 2. Quais sao os 10 pedidos mais recentes?
SELECT order_id, order_purchase_timestamp
FROM orders
ORDER BY order_purchase_timestamp DESC
LIMIT 10;
-- resultado: mais recente em 17/10/2018 (fim da base)

-- 3. Quantos clientes tem cada estado, do maior pro menor?
SELECT customer_state, COUNT(*) AS total
FROM customers
GROUP BY customer_state
ORDER BY total DESC;
-- resultado: SP lidera com 41746, depois RJ e MG

-- 4. Quantos pedidos existem em cada status?
SELECT order_status, COUNT(*) AS total
FROM orders
GROUP BY order_status
ORDER BY total DESC;
-- resultado: 96478 entregues (cerca de 97%)

-- 5. Quantos pedidos por mes, em ordem de mes?
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS mes, COUNT(*) AS total
FROM orders
GROUP BY mes
ORDER BY mes;
-- resultado: pico em nov/2017 (Black Friday); meses das pontas com poucos pedidos (dados incompletos)

-- 6. Quantos pedidos vieram de cada estado?
SELECT customers.customer_state, COUNT(*) AS total
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_state
ORDER BY total DESC;
-- resultado esperado: SP lidera com 41746 pedidos, seguido por RJ e MG

-- 7. Quanto cada categoria faturou, com o nome em ingles?
SELECT category_translation.product_category_name_english, SUM(price) AS faturamento
FROM order_items
JOIN products
    ON order_items.product_id = products.product_id
JOIN category_translation
    ON products.product_category_name = category_translation.product_category_name
GROUP BY category_translation.product_category_name_english;

  -- resultado: entre as 71 categorias com traducao, health_beauty teve o maior
  -- faturamento, com R$ 1.258.681,34 em itens vendidos, sem incluir o frete.

-- 8. Quais categorias venderam mais de 1000 itens?
SELECT products.product_category_name, COUNT(*) AS total
FROM order_items
JOIN products
    ON products.product_id = order_items.product_id
GROUP BY products.product_category_name
HAVING COUNT(*) > 1000;
-- resultado: 21 categorias com nome passaram de 1000 itens.
-- cama_mesa_banho liderou com 11115 itens. O grupo sem categoria teve 1603.

-- 9. Qual e o ticket medio por forma de pagamento?
WITH totais_por_pedido AS (
    SELECT order_id, payment_type, SUM(payment_value) AS total_pago
    FROM order_payments
    GROUP BY order_id, payment_type
)
SELECT payment_type, AVG(total_pago) AS ticket_medio
FROM totais_por_pedido
GROUP BY payment_type;
-- resultado: nos pedidos que usaram cartao de credito, o valor medio
-- pago com cartao de credito foi de R$ 163,94 por pedido.

-- 10. Quantos pedidos ficaram sem avaliacao?
SELECT COUNT(*) AS total
FROM orders
LEFT JOIN order_reviews
    ON orders.order_id = order_reviews.order_id
WHERE order_reviews.review_id IS NULL;
-- resultado: 768 pedidos ficaram sem avaliacao.
  
-- 11. Quantas unidades foram vendidas para cada estado e qual categoria mais vendeu em cada um?

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
           -- Procura a categoria mais vendida dentro do estado atual.
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

-- resultado: SP liderou com 47449 unidades no total.
-- A categoria mais vendida em SP foi cama_mesa_banho.  