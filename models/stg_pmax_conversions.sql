SELECT
    _AIRBYTE_RAW_ID,
    _AIRBYTE_EXTRACTED_AT,
    "SEGMENTS.DATE"                    AS date,
    "CAMPAIGN.ID"                      AS campaign_id,
    "SEGMENTS.CONVERSION_ACTION_NAME"  AS conversion_action_name,
    "METRICS.ALL_CONVERSIONS"          AS conversions,
    ROW_NUMBER() OVER (
        PARTITION BY "CAMPAIGN.ID", "SEGMENTS.DATE", "SEGMENTS.CONVERSION_ACTION_NAME"
        ORDER BY _AIRBYTE_EXTRACTED_AT DESC
    ) AS rn
FROM {{ source('google_ads', 'PMAX_CONVERSIONS') }}
QUALIFY rn = 1
