-- 1. Quantos clientes sao de SP?
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

