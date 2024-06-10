WITH CountryRevenue AS (
    SELECT
        country,
        SUM(totalTransactionRevenue) AS total_revenue
    FROM
        "ecommerce-session-bigquery"
    GROUP BY
        country
    ORDER BY
        total_revenue DESC
    LIMIT 5
)

SELECT
    cr.country,
    e.channelGrouping,
    SUM(e.totalTransactionRevenue) AS total_channel_revenue
FROM
    "ecommerce-session-bigquery" e
JOIN
    CountryRevenue cr ON e.country = cr.country
GROUP BY
    cr.country, e.channelGrouping
ORDER BY
    cr.country, total_channel_revenue DESC;
