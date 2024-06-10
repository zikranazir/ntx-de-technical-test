WITH ProductMetrics AS (
    SELECT
        v2ProductName,
        SUM(productRevenue) AS total_revenue,
        SUM(productQuantity) AS total_quantity_sold,
        SUM(productRefundAmount) AS total_refund_amount,
        (SUM(productRevenue) - SUM(productRefundAmount)) AS net_revenue
    FROM
        "ecommerce-session-bigquery"
    GROUP BY
        v2ProductName
),
RankedProducts AS (
    SELECT
        v2ProductName,
        total_revenue,
        total_quantity_sold,
        total_refund_amount,
        net_revenue,
        RANK() OVER (ORDER BY net_revenue DESC) AS product_rank,
        CASE
            WHEN total_refund_amount > 0.1 * total_revenue THEN 'Flagged'
            ELSE 'Not Flagged'
        END AS refund_flag
    FROM
        ProductMetrics
)

SELECT
    v2ProductName,
    total_revenue,
    total_quantity_sold,
    total_refund_amount,
    net_revenue,
    product_rank,
    refund_flag
FROM
    RankedProducts
ORDER BY
    product_rank;
