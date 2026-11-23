CREATE TABLE IF NOT EXISTS customers (
    customer_id   VARCHAR(32) PRIMARY KEY,
    customer_unique_id  VARCHAR(32),
    customer_zip_code_prefix  VARCHAR(5),
    customer_city   TEXT,
    customer_state  CHAR(2)
);

CREATE TABLE IF NOT EXISTS sellers (
    seller_id     VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city TEXT,
    seller_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS products (
    product_id    VARCHAR(32) PRIMARY KEY,
    product_category_name  TEXT,
    product_name_length    INTEGER,
    product_description_length  INTEGER,
    product_photos_qty  INTEGER,
    product_weight_g  INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm  INTEGER
);

CREATE TABLE IF NOT EXISTS category_translation (
    product_category_name   TEXT PRIMARY KEY, 
    product_category_name_english TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    order_id                       VARCHAR(32) PRIMARY KEY,
    customer_id                    VARCHAR(32) REFERENCES customers(customer_id),
    order_status                   TEXT,
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);


CREATE TABLE IF NOT EXISTS order_items (
    order_id             VARCHAR(32) REFERENCES orders(order_id),
    order_item_id        INTEGER,
    product_id           VARCHAR(32) REFERENCES products(product_id),
    seller_id            VARCHAR(32) REFERENCES sellers(seller_id),
    shipping_limit_date  TIMESTAMP,
    price                NUMERIC(10,2),
    freight_value        NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE IF NOT EXISTS order_payments (
    order_id             VARCHAR(32) REFERENCES orders(order_id),
    payment_sequential   INTEGER,
    payment_type         TEXT,
    payment_installments INTEGER,
    payment_value        NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)   
);                                                

CREATE TABLE IF NOT EXISTS order_reviews (
    review_id               VARCHAR(32),
    order_id                VARCHAR(32) REFERENCES orders(order_id),
    review_score            INTEGER,
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);
