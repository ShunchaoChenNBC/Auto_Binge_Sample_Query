select Adobe_Date, 
count(distinct Adobe_Tracking_ID) as accts,
round(sum(New_Watch_Time)/3600,1) as Hours,
round(sum(New_Watch_Time)/(3600*count(distinct Adobe_Tracking_ID)),2) as Watch_Hours_per_acct
FROM `nbcu-ds-sandbox-a-001.Shunchao_Sandbox_Final.Auto_Binge_Metadata_V2`
WHERE New_Watch_Time > 0
  AND Feeder_Video != ''
  AND Feeder_Video IS NOT NULL
  AND video_start_type = "Auto-Play"
  AND Feeder_Video = "bel-air"
  AND display_name = "grand crew"
group by 1
order by 1 desc
