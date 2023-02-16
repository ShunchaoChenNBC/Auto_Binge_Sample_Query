
with cte as (select 
a.*,
dense_rank() over (partition by Adobe_Date, Feeder_Video order by Auto_Binge_Counts desc) as rk
from
(SELECT Adobe_Date, 
Feeder_Video, 
Display_Name,
count(distinct Adobe_Tracking_ID) as Auto_Binge_Counts,
round(sum(New_Watch_Time)/3600,1) as Auto_Binge_Hours
FROM `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_Pro` 
where New_Watch_Time > 0 
and  adobe_date = current_date("America/New_York")-1
and Feeder_Video is not null 
and Feeder_Video != "" 
and video_start_type = "Auto-Play" 
and Display_Name not like "%trailer%"
and Feeder_Video not in (SELECT 
                         regexp_replace(lower(content_channel), r"[:,.&'!]", '')
                         FROM `nbcu-ds-prod-001.PeacockDataMartSilver.SILVER_VIDEO` 
                         WHERE 1=1
                         and adobe_date = current_date("America/New_York")-1
                         and content_channel != "N/A"
                         group by 1)  -- remove linear channels from the result
group by 1,2,3) a)


select 
Adobe_Date,
Feeder_Video as Binge_From,
Display_Name as Binge_To,
Auto_Binge_Counts,
Auto_Binge_Hours,
round(Auto_Binge_Hours/Auto_Binge_Counts,2) as Hours_per_ID
from cte
where rk = 1 and Auto_Binge_Counts >= 1000
order by 1 desc, Auto_Binge_Counts desc
