
-- The script calculate how many of those binged accounts played the show (e.g."based on a true story") for the first time through auto-play


with Auto_Binge_ID as (select 
Adobe_Tracking_ID as Auto_ID,
min(Adobe_Timestamp) as Auto_Binge_Time
from `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_Prod`
where Final_Watch_Time > 0
and lower(Display_Name) like "%based%on%a%true%story%"
and Adobe_Date > "2023-06-07"
and Video_Start_Type in ("Clicked-Up-Next","Auto-Play")
and Feeder_Video in ('renfield','vanderpump rules','yellowstone' )
group by 1),

Watch_ID as (
select 
adobe_tracking_id as SV_ID,
min(adobe_timestamp) as Watched_Time
from `nbcu-ds-prod-001.PeacockDataMartSilver.SILVER_VIDEO` s
where 1=1
and adobe_date > "2023-06-07"
and num_seconds_played_no_ads > 300
and lower(s.display_name) like "%based%on%a%true%story%" and lower(s.display_name) not like '%trailer%'
and lower(consumption_type_detail) = "vod" 
group by 1
)

select count(distinct Auto_ID) as Auto_IDs
from Watch_ID, Auto_Binge_ID
where Auto_Binge_Time < Watched_Time and SV_ID = Auto_ID
