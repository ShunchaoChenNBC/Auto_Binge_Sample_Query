with Auto_Binge as (SELECT  
Adobe_Tracking_ID,
min(Adobe_Date) as Auto_Binge_Date,
min(Adobe_Timestamp) as Auto_Start_Stamp
FROM `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_V2` 
where lower(Feeder_Video) = "the best man the final chapters" and lower(Display_Name) = "grand crew" and New_Watch_Time > 0
and Video_Start_Type in ("Auto-Play", "Clicked-Up-Next")
group by 1),

Manual as (
select
Adobe_Tracking_ID,
min(Adobe_Date) as Manual_Date,
min(Adobe_Timestamp) as Manual_Start_Stamp
FROM `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_V2` 
where lower(Display_Name) = "grand crew" and New_Watch_Time > 0
and Video_Start_Type = 'Manual-Selection'
group by 1),

temp_table as (select 
a.*,
Manual_Date,
DATE_DIFF(Manual_Date, Auto_Binge_Date, DAY) as Date_Gap
from Auto_Binge as a
left join Manual m on a.Adobe_Tracking_ID = m.Adobe_Tracking_ID and a.Auto_Start_Stamp < m.Manual_Start_Stamp)


select Date_Gap,
count (distinct Adobe_Tracking_ID) as Accts
from temp_table as t1
group by 1
order by 1



