
# add column for csos and ms4s
# write out to test

library(sf)
library(tidyverse)
library(leaflet)

poly <- st_read("~/Documents/spatial/SAVI/hudson_access/data/published/data/hap_site_polys_20240201.geojson")
point <- st_read("~/Documents/spatial/SAVI/hudson_access/data/published/data/hap_site_points_20240304.geojson")
act <- st_read("~/Documents/spatial/SAVI/hudson_access/data/published/data/hap_act_points_20240201.geojson")

csos <- st_read("data/published/data/staging/csos_20240115.geojson")


ms4 <- st_read("data/published/data/staging/ms4s_20240115.geojson")

halfmile <- st_read("/Users/sarahodges/Documents/spatial/SAVI/hudson_access/data/geo/working/half_mile_buffer_spring2023/half_mile_buffer_website_extent.shp")

### select ms4 within 1/5 mile of waterfront
ms4_waterfront <- st_intersection(ms4, halfmile)


write_sf(ms4_waterfront, "data/published/data/staging/ms4s_within_halfmile.geojson")

cso_buffer <- st_buffer(csos, dist = 2640) |> 
  select(CSO_ID)

ms4_buffer <- st_buffer(ms4_waterfront, dist = 2640)


# cso_buffer_4326 <- st_transform(cso_buffer, 4326)
# ms4_buffer_4326 <- st_transform(ms4_buffer, 4326)
# halfmile_4326 <- st_transform(halfmile, 4326)
# 
# leaflet() %>% 
#   addProviderTiles(provider = "CartoDB.Positron") %>% 
#   addPolygons(data = halfmile_4326,
#               color = "ababab",
#               fillColor = "yellow",
#               fillOpacity = 0.5 ) %>% 
#   addPolygons(data = cso_buffer_4326,
#               color = "ababab",
#               fillColor = "purple") %>% 
#   addPolygons(data = ms4_buffer_4326,
#               color = "ababab",
#               fillColor = "red")
