#### correcting

library(sf)
library(tidyverse)

### reading in current data, I added Bush Terminal Parkfishing point
poly <- st_read("data/published/data/hap_site_polys_20230921.geojson")
point <- st_read("data/published/data/hap_site_points_20230921.geojson")
act <- st_read("data/published/data/hap_act_points_20230921.geojson")


new_point <- point |> 
  mutate(site_name_photo_01 = ifelse(site_id == 189, "stapleton_waterfront_park_01.jpg", site_name_photo_01),
         site_name_photo_02 = ifelse(site_id == 189, "stapleton_waterfront_park_02.jpg", site_name_photo_02),
         site_name_photo_03 = ifelse(site_id == 189, "stapleton_waterfront_park_03.jpg", site_name_photo_03),
         site_name_photo_01 = ifelse(site_id == 98, "breezypoint_01.jpg", site_name_photo_01),
         site_name_photo_02 = ifelse(site_id == 98, "breezypoint_02.jpg", site_name_photo_02),
         site_name_photo_03 = ifelse(site_id == 98, "breezypoint_03.jpg", site_name_photo_03))

breezy <- new_point |> 
  filter(site_id == 98)

st_write(new_point, "data/published/data/hap_site_points_20231204.geojson")
  
  



