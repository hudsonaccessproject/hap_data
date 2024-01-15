library(sf)
library(tidyverse)

### reading in current data, I added Bush Terminal Parkfishing point
poly <- st_read("~/spatial/SAVI/hudson_access/data/published/data/staging/hap_site_polys_20240114.geojson")
new_point <- st_read("data/published/data/staging/hap_site_points_20240115.geojson")
act <- st_read("data/published/data/staging/hap_activity_points_20240115.geojson")

point <- new_point |> 
  mutate(site_name_photo_01 = ifelse(site_id == 53, NA, site_name_photo_01),
         site_name_photo_02 = ifelse(site_id == 53, NA, site_name_photo_02),
         site_name_photo_03 = ifelse(site_id == 53, NA, site_name_photo_03))

write_sf(point, "data/published/data/hap_site_points_20240115.geojson")
write_sf(act, "data/published/data/hap_act_points_20240115.geojson")
write_sf(poly, "data/published/data/hap_site_polys_20240115.geojson")
