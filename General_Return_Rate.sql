
with All_Watches as (
select count (distinct Adobe_Tracking_ID) All_Watch_Accounts,
from `nbcu-ds-prod-001.PeacockDataMartSilver.SILVER_VIDEO` 
where num_seconds_played_no_ads > 0 and  Adobe_Date between  "2023-01-26" and "2023-02-01" 
AND lower(display_name) = "the resort"
), ID as 
(select Adobe_Tracking_ID,
  min(Adobe_Timestamp) as start
from `nbcu-ds-prod-001.PeacockDataMartSilver.SILVER_VIDEO` 
where num_seconds_played_no_ads > 0 and  Adobe_Date between  "2023-01-26" and "2023-02-01" 
AND lower(display_name) = "the resort"
group by 1),

ms as (
select Adobe_Tracking_ID,
  max(Adobe_Timestamp) as start,
  round(sum(num_seconds_played_no_ads)/3600,1) as total_hours
from `nbcu-ds-prod-001.PeacockDataMartSilver.SILVER_VIDEO` 
where num_seconds_played_no_ads > 0 and  Adobe_Date between  "2023-01-26" and "2023-02-01" 
AND lower(display_name) = "the resort"
group by 1
),

Return_Watches as (select 
count(distinct ID.Adobe_Tracking_ID) Returning_Accts
from ID, ms
where ID.Adobe_Tracking_ID = ms.Adobe_Tracking_ID
AND ID.start < ms.start)

select 
All_Watch_Accounts,
Returning_Accts,
round(Returning_Accts / All_Watch_Accounts,1) as Return_Rate
from Return_Watches, All_Watches
