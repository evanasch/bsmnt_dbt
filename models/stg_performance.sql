SELECT
    _AIRBYTE_RAW_ID,
    _AIRBYTE_EXTRACTED_AT,
    "AD_GROUP.NAME"                    AS ad_group_name,
    "CAMPAIGN.NAME"                    AS campaign_name,
    "SEGMENTS.DATE"                    AS date,
    "AD_GROUP_AD.AD.ID"                AS ad_id,
    "AD_GROUP_AD.AD.NAME"              AS ad_name,
    "METRICS.CLICKS"                   AS clicks,
    "METRICS.IMPRESSIONS"              AS impressions,
    "METRICS.COST_MICROS" / 1000000    AS media_cost,
    "METRICS.INTERACTIONS"             AS interactions,
    "METRICS.VIDEO_TRUEVIEW_VIEWS"     AS views,
    "METRICS.VIDEO_QUARTILE_P100_RATE" AS video_completion_rate,
    ROW_NUMBER() OVER (
        PARTITION BY "AD_GROUP_AD.AD.ID", "SEGMENTS.DATE"
        ORDER BY _AIRBYTE_EXTRACTED_AT DESC
    ) AS rn
FROM {{ source('google_ads', 'PERFORMANCE') }}
QUALIFY rn = 1
