WITH UserMetrics AS (
    SELECT
        fullVisitorId,
        AVG(timeOnSite) AS avg_timeOnSite,
        AVG(pageviews) AS avg_pageviews,
        AVG(sessionQualityDim) AS avg_sessionQualityDim
    FROM
        "ecommerce-session-bigquery"
    GROUP BY
        fullVisitorId
),
OverallAverages AS (
    SELECT
        AVG(timeOnSite) AS overall_avg_timeOnSite,
        AVG(pageviews) AS overall_avg_pageviews
    FROM
        "ecommerce-session-bigquery"
)

SELECT
    u.fullVisitorId,
    u.avg_timeOnSite,
    u.avg_pageviews,
    u.avg_sessionQualityDim
FROM
    UserMetrics u,
    OverallAverages o
WHERE
    u.avg_timeOnSite > o.overall_avg_timeOnSite
    AND u.avg_pageviews < o.overall_avg_pageviews
ORDER BY
    u.avg_timeOnSite DESC;
