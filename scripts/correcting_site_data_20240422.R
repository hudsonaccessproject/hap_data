#### correcting

library(sf)
library(tidyverse)

# site_points_old <- st_read("data/published/data/hap_site_points_20240304.geojson")

### reading in current data, I added Bush Terminal Parkfishing point
# poly <- st_read("data/published/data/hap_site_polys_20230921.geojson")
point <- read_csv("/Users/sarahodges/Downloads/site_points_20240417.csv")
# act <- st_read("data/published/data/hap_act_points_20230921.geojson")

site_points <- st_as_sf(point, coords = c("lon", "lat"), crs=4326) |> 
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2)),
         near_cso = ifelse(near_cso == "1", "Y", near_cso))

st_write(site_points, "data/published/data/hap_site_points_20240422.geojson")
st_write(site_points, "data/published/website/hap/public/assets/hap_site_points_20240422.geojson")
  
  



