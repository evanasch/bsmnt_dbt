SELECT
    _AIRBYTE_RAW_ID,
    _AIRBYTE_EXTRACTED_AT,
    "SEGMENTS.DATE"                    AS date,
    "AD_GROUP_AD.AD.ID"                AS ad_id,
    "SEGMENTS.CONVERSION_ACTION_NAME"  AS conversion_action_name,
    "METRICS.ALL_CONVERSIONS"          AS conversions,
    ROW_NUMBER() OVER (
        PARTITION BY "AD_GROUP_AD.AD.ID", "SEGMENTS.DATE", "SEGMENTS.CONVERSION_ACTION_NAME"
        ORDER BY _AIRBYTE_EXTRACTED_AT DESC
    ) AS rn
FROM {{ source('google_ads', 'CONVERSION') }}
QUALIFY rn = 1
