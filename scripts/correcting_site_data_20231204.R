#### correcting

library(sf)
library(tidyverse)

### reading in current data, I added Bush Terminal Parkfishing point
poly <- st_read("data/published/data/hap_site_polys_20230921.geojson")
point <- st_read("data/published/data/hap_site_points_20230921.geojson")
act <- st_read("data/published/data/hap_act_points_20230921.geojson")



