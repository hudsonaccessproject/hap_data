library(sf)
library(tidyverse)

# ### reading in current data, I added Bush Terminal Parkfishing point
# poly <- st_read("~/spatial/SAVI/hudson_access/data/published/data/staging/hap_site_polys_20240114.geojson")
# new_point <- st_read("data/published/data/staging/hap_site_points_20240115.geojson")
# act <- st_read("data/published/data/staging/hap_activity_points_20240115.geojson")
# 
# point <- new_point |> 
#   mutate(site_name_photo_01 = ifelse(site_id == 53, NA, site_name_photo_01),
#          site_name_photo_02 = ifelse(site_id == 53, NA, site_name_photo_02),
#          site_name_photo_03 = ifelse(site_id == 53, NA, site_name_photo_03),
#          site_name_photo_01 = ifelse(site_id == 6, "great_kills_park_01.JPG", site_name_photo_01),
#          site_name_photo_02 = ifelse(site_id == 6, "great_kills_park_02.JPG", site_name_photo_02),
#          site_name_photo_03 = ifelse(site_id == 6, "great_kills_park_03.JPG", site_name_photo_03))
# 
# write_sf(point, "data/published/data/hap_site_points_20240115.geojson")
# write_sf(act, "data/published/data/hap_act_points_20240115.geojson")
# write_sf(poly, "data/published/data/hap_site_polys_20240115.geojson")


poly <- st_read("~/spatial/SAVI/hudson_access/data/published/data/staging/hap_site_polys_20240130.geojson")
point <- st_read("data/published/data/staging/hap_site_points_20240130.geojson")
act <- st_read("data/published/data/staging/hap_act_points_20240130.geojson")

# poly_rahway <- st_read("data/temp/rahway_river_parks_adjusted.geojson") |>
#   mutate(ms4 = as.numeric(ms4),
#          cso = as.numeric(cso))
# 
# updated_poly <- st_read("data/temp/updated_site_poly.geojson") |> 
#   mutate(ms4 = as.numeric(ms4),
#          cso = as.numeric(cso))
# 
# new_poly <- poly |> 
#   rbind(poly_rahway)


new_act <- act |> 
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2)))

new_point <- point |> 
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2)),
         x = unlist(map(geometry,1)),
         y = unlist(map(geometry,2)))

write_sf(new_point, "data/published/data/hap_site_points_20240201.geojson")
write_sf(new_act, "data/published/data/hap_act_points_20240201.geojson")
write_sf(poly, "data/published/data/hap_site_polys_20240201.geojson")

# write_sf(updated_poly, "data/published/data/hap_site_polys_20240131.geojson")
