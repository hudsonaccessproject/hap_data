### assess polygons
library(tidyverse)
library(sf)


raw_poly <- st_read("data/published/data/hap_site_polys_20230913.geojson") 
raw_point <- st_read("data/published/data/hap_site_points_20230913.geojson")
raw_act <- st_read("data/published/data/hap_act_points_20230913.geojson") 

# site_id_dupes <- st_drop_geometry(raw_point) |> 
#   group_by(site_id) |> 
#   summarise(count = n(),
#             site_name = toString(site_name)) |> 
#   filter(count > 1)


### make corrections to existing
point <- raw_point |> 
  filter(site_id != 165, # remove francis lewis park dupe
         site_id != 59, # remove barretto point park dupe
         site_id != 110, # remove battery park park dupe
         site_id != 89, # remove brooklyn bridge park dupe
         site_id != 7, # remove east river esplanade at 90th st park dupe
         site_id != 599493, # remove firefighters park dupe
         site_id != 67622, # gowanus dredgers was moved into spinge park
         site_id != 599400, # remove mariner's landing, dupe of grand cove marina
         site_id != 645880, # remove dupe of horan's landing
         site_id != 4114, # remove pier 40 dupe
         site_id != 38901, # hunt's point landing dupe
         site_id != 285141, # hudson river walkway in weehawken dupe
         site_id != 284411, # hudson river walkway in weehawken dupe 
         site_id != 647496, # liberty state Park dupe 
         site_id != 601699, # maxwell place Park dupe
         site_id != 595109, # monmouth cover marina dupe 
         site_id != 649160, # north 5th dupe
         site_id != 166, # norton dupe
         site_id != 270237, # palisades medical center dupe
         site_id != 596578, # richard  rutkowski dupe
         site_id != 598801, # riverside parlk piscatway dupe
         site_id != 183131, # rockaway beach dupe
         site_id != 599032, # seven presidents dupe
         site_id != 900139, # removing Alyssa's Narrows Botanical Park - no water access
         site_id != 318951, # cleaning up jersey city waterfront
         site_id != 306897, # cleaning up jersey city waterfront
         site_id != 306843, # cleaning up jersey city waterfront
         site_id != 326557, # cleaning up jersey city waterfront
         site_id != 311119, # cleaning up jersey city waterfront
         site_id != 188401, # removing conference park dupe
         site_id != 147570, # removing marina that doesn't exist
         site_id != 174) |>  # remove bayswater park dupe
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2))) ### replacing lat long since I manually moved some in qgis

act <- raw_act |> 
  mutate(act_id = ifelse(is.na(act_id), "999_FISH", act_id)) |> 
  filter(site_id != 165, # remove francis lewis park dupe
         site_id != 59, # remove barretto point park dupe
         site_id != 110, # remove battery park park dupe
         site_id != 89, # remove brooklyn bridge park dupe
         site_id != 7, # remove east river esplanade at 90th st park dupe
         site_id != 599493, # remove firefighters park dupe
         site_id != 67622, # gowanus dredgers was moved into spinge park
         site_id != 599400, # remove mariner's landing, dupe of grand cove marina
         site_id != 645880, # remove dupe of horan's landing
         site_id != 4114, # remove pier 40 dupe
         site_id != 38901, # hunt's point landing dupe
         site_id != 285141, # hudson river walkway in weehawken dupe
         site_id != 284411, # hudson river walkway in weehawken dupe
         site_id != 647496, # liberty state Park dupe 
         site_id != 601699, # maxwell place Park dupe 
         site_id != 595109, # monmouth cover marina dupe 
         site_id != 649160, # north 5th dupe
         site_id != 166, # norton dupe
         site_id != 270237, # palisades medical center dupe
         site_id != 596578, # richard  rutkowski dupe
         site_id != 598801, # riverside parlk piscatway dupe
         site_id != 183131, # rockaway beach dupe
         site_id != 599032, # seven presidents dupe
         site_id != 318951, # cleaning up jersey city waterfront
         site_id != 306897, # cleaning up jersey city waterfront
         site_id != 306843, # cleaning up jersey city waterfront
         site_id != 326557, # cleaning up jersey city waterfront
         site_id != 311119, # cleaning up jersey city waterfront
         site_id != 188401, # removing conference park dupe
         site_id != 147570, # removing marina that doesn't exist
         act_id != "139_MPBL", # removing random activity point
         site_id != 174) |>  # remove bayswater park dupe
  mutate(lon = unlist(map(geometry,1)),
         lat = unlist(map(geometry,2)), ### replacing lat long since I manually moved some in qgis
         site_id = ifelse(site_name == "Nutley Boat Ramp", 4313409, site_id),
         site_id = ifelse(site_name == "Bayswater Point State Park", 164, site_id),
         site_id = ifelse(site_name == "Hunt's Point Riverside Park", 31177, site_id))

## small point spatial df to get the correct site ids for the polygons
point_sm <- point |> 
  select(site_id, site_name, act_codes) 
# |>
#   rename(site_id_pt = site_id,
#          site_name_pt = site_name,
#          act_codes_pt = act_codes)

point_sm_df <- st_drop_geometry(point_sm) |>
  rename(site_id_pt = site_id,
         site_name_pt = site_name,
         act_codes_pt = act_codes)

poly <- raw_poly |> 
  filter(site_id != "NA") |> 
  select(-path, -layer, -access_id) |> 
  group_by(join) |> 
  summarise(site_id_poly = first(site_id)) |> 
  mutate(site_id_poly = as.numeric(site_id_poly)) |> 
  st_join(point_sm)
### this is the poly with site id for the polygons that overlap (many parks are a gorup of polygons and
# they have note been dissolved)

poly_new <- poly |> 
  right_join(point_sm_df, by = c("site_id_poly" = "site_id_pt")) |> 
  mutate(site_id = ifelse(is.na(site_id), site_id_poly, site_id),
         site_name = ifelse(is.na(site_name), site_name_pt, site_name),
         act_codes = ifelse(is.na(act_codes), act_codes_pt, act_codes)) |> 
  select(site_id, site_name, act_codes, geometry)

# poly_left <- poly |> 
#   left_join(point_sm_df, by = c("site_id_poly" = "site_id_pt")) |> 
#   mutate(site_id = ifelse(is.na(site_id), site_id_poly, site_id),
#          site_name = ifelse(is.na(site_name), site_name_pt, site_name),
#          act_codes = ifelse(is.na(act_codes), act_codes_pt, act_codes))
# write_sf(poly_new, "/Users/sarahodges/Downloads/poly_test.shp")
# 
# site_id_no_match <- poly |>
#   filter(site_id_pt != site_id)

#### make df versions
df_act <- st_drop_geometry(act)

df_points <- st_drop_geometry(point) 

df_poly <- st_drop_geometry(poly_new)

##### checking for errors to make corrections above
#### check for dupe polys
poly_dupe <- df_poly |> 
  group_by(site_id) |> 
  summarise(count = n(),
            names = toString(site_name)) |> 
  filter(count > 1)

pt_name_dupe <- df_points |> 
  group_by(site_name) |> 
  summarise(count = n(),
            site_name = toString(site_name),
            act_codes = toString(act_codes)) |> 
  filter(count > 1)

## act grouped by site
act_sites <- df_act |> 
  group_by(site_id) |> 
  summarise(count = n(),
            act = toString(activity))

## sites with no activity
sites_no_act <- df_points |> 
  left_join(act_sites, by = "site_id") |> 
  filter(is.na(count))

## acts with no sites
acts_no_site <- df_act |> 
  full_join(point_sm_df, by = c("site_id" = "site_id_pt")) 

df_poly_test <- df_poly |> 
  select(site_id) |> 
  mutate(poly = "poly")

## sites with no poly
sites_no_poly <- df_points |> 
  left_join(df_poly_test, by = "site_id")|> 
  filter(is.na(poly))

###### final test for poly

poly_sh <- poly_new |> 
  select(site_id, site_name, geometry) |> 
  rename(site_name_poly = site_name) |> 
  mutate(poly = "poly")

site_sh <- point_sm |> 
  st_join(poly_sh) |> 
  filter(is.na(site_id.y))
#### there are 72 but I think they might just not intersect, will check later

### writing out
write_sf(poly_new, "data/published/data/hap_site_polys_20230921.geojson")
write_sf(point, "data/published/data/hap_site_points_20230921.geojson")
write_sf(act, "data/published/data/hap_act_points_20230921.geojson")
