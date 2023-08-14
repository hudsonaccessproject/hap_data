library(sf)
library(tidyverse)

### act point ___ FIXING rows that have multuple activities
act_points_current <- st_read("/Users/sarahodges/Downloads/hap_activity_points (1).geojson") 

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
  rbind(fixed)

act_points_sf <- st_as_sf(act_points_current_fixed, coords = c("lon", "lat"), crs=4326) 


write_sf(act_points_sf, )