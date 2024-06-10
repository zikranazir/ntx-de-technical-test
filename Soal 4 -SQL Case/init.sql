-- Membuat tabel dengan kolom yang dipilih
CREATE TABLE ecommerce_session (
    channel_grouping TEXT,
    country TEXT,
    full_visitor_id TEXT,
    time_on_site INTEGER,
    pageviews INTEGER,
    session_quality_dim INTEGER,
    v2_product_name TEXT,
    product_revenue NUMERIC,
    product_quantity INTEGER,
    product_refund_amount NUMERIC
);

-- Memuat data dari file CSV ke dalam tabel
COPY ecommerce_session(channel_grouping, country, full_visitor_id, time_on_site, pageviews, session_quality_dim, v2_product_name, product_revenue, product_quantity, product_refund_amount)
FROM '/docker-entrypoint-initdb.d/ecommerce-session-bigquery.csv'
DELIMITER ','
CSV HEADER;
