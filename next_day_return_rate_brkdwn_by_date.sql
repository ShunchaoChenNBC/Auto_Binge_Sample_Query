with ID as 
( select 
adobe_date,
Adobe_Tracking_ID,
  min(Adobe_Timestamp) as start
from  `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_Prod`
where Final_Watch_Time > 0
and  Video_Start_Type in  ('Auto-Play', 'Clicked-Up-Next')
and lower(Display_Name) = "mrs davis"
and Adobe_Date between "2023-04-20" and "2023-05-01"
group by 1,2),

ms as (
select 
adobe_date,
Adobe_Tracking_ID,
  min(Adobe_Timestamp) as start,
  round(sum(Final_Watch_Time)/3600,2) as total_hours
from  `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_Prod`
where Final_Watch_Time > 0
and Video_Start_Type = 'Manual-Selection'
and lower(Display_Name) = "mrs davis"
and Adobe_Date between "2023-04-20" and "2023-05-01"
group by 1,2
)

select 
ID.adobe_date,
count(distinct ID.Adobe_Tracking_ID) returning_accts,
round(sum(ms.total_hours),2) returning_hours
from ID, ms
where ID.Adobe_Tracking_ID = ms.Adobe_Tracking_ID and ID.adobe_date = ms.adobe_date - 1
AND ID.start < ms.start
group by 1

