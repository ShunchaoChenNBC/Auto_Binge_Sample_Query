
with cte as (select 
a.*,
dense_rank() over (partition by Adobe_Date, Feeder_Video order by counts desc) as rk
from
(SELECT Adobe_Date, 
Feeder_Video, 
Display_Name,
count(distinct Adobe_Tracking_ID) as counts,
FROM `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_Pro` 
where New_Watch_Time > 0 and Feeder_Video is not null and Feeder_Video != "" and video_start_type = "Auto-Play" and Display_Name not like "%trailer%"
group by 1,2,3) a)


select 
Adobe_Date,
Feeder_Video as Binge_From,
Display_Name as Binge_To,
from cte
where rk = 1 and counts >= 1000 -- filter out the noises
order by 1 desc, counts desc

