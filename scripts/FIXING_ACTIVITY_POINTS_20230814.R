library(sf)
library(tidyverse)

### act point ___ FIXING rows that have multuple activities
act_points_current <- st_read("data/processed/current/hap_activity_points.geojson")

website_act_points_current <- st_read("data/processed/current/hap_activity_points.geojson")


tofix <- act_points_current |> 
  filter(grepl(",", activity)) |> 
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2))) |> 
  st_drop_geometry()

# write_csv(tofix, "/Users/sarahodges/Downloads/to_fix.csv")

fixed <- read_csv("/Users/sarahodges/Downloads/to_fix.csv")

act_points_current_fixed <- act_points_current |> 
  filter(!grepl(",", activity)) |> 
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2))) |> 
  st_drop_geometry() |> 
  filter(access_id != "1447") |> 
  rbind(fixed) |> 
  mutate(access_id = ifelse(site_id == 71975, 1621, access_id),
         access_id = str_split(access_id, ",") |> 
           sapply(function(x) ifelse(length(x) > 0, x[1], "")),
         act_id = paste(access_id, activity, sep = "_")) |> 
  select(act_id:activity, access_name, lon, lat) |> 
  filter(site_id != "remove dupe") |> 
  mutate(access_id = as.numeric(access_id))

act_points_sf <- st_as_sf(act_points_current_fixed, coords = c("lon", "lat"), crs=4326) 


write_sf(act_points_sf, "/Users/sarahodges/spatial/SAVI/hudson_access/data/published/data/data_updates/correcting_activity_points_20230814/hap_activity_points_20230815.geojson")
