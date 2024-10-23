library(sf)
library(tidyverse)
library(cleangeo)

site_points_fulcrum_temp <- st_read("data/published/data/data_updates/fulcrum/update_20241011/hap_site_points_fulcrum_export_10-11-2024.geojson")

act_points_fulcrum <- st_read("data/published/data/data_updates/fulcrum/update_20241011/hap_act_points_fulcrum_export_10-11-2024.geojson")
# 
site_poly_fulcrum <- st_read("data/published/website/hap/public/assets/hap_site_poly_20240913.geojson") |> 
  select(site_id, site_name, near_cso, geometry)
## existing points

current_site_points <- st_read("data/published/website/hap/public/assets/hap_site_points_20240913.geojson")

# join_site_id <- st_drop_geometry(current_site_points) |> 
#   select(site_id, site_name) |> 
#   rename(site_id_c = site_id,
#          site_name_c = site_name) |> 
#   distinct()

join_site_id <- current_site_points |> 
  select(site_id, site_name) |> 
  rename(site_id_c = site_id,
         site_name_c = site_name) 

### this fixes the problem of assigning a different site id 
site_points_fulcrum <- site_points_fulcrum_temp |> 
  st_join(join_site_id) |> 
  # select(OBJECTID, site_id, site_name, site_id_c, site_name_c) |> 
  mutate(site_id = ifelse(is.na(site_id), site_id_c, site_id)) |> 
  select(-site_name_c, -site_id_c)

# site_points_fulcrum_c <- st_drop_geometry(site_points_fulcrum_temp) |> 
#   left_join(join_site_id, by = "site_name") |> 
#   select(OBJECTID, site_id, site_name, site_id_c) |> 
#   filter(is.na(site_id) & !is.na(site_id_c)) |> 
#   select(OBJECTID, site_id_c)
# 
# ### add site id that I had added last time around
# site_points_fulcrum <- site_points_fulcrum_temp |> 
#   left_join(site_points_fulcrum_c, by = "OBJECTID") |> 
#   mutate(site_id = ifelse(is.na(site_id), site_id_c, site_id))


# #### this are the polygons that Sara E updated - I didn't use them because there are some weird empty polygons
# poly <- st_read("data/published/data/data_updates/fulcrum/update_20240829/fromSaraE/current_poly.geojson") |>
#   select(site_id, site_name, near_cso, geometry)
# ### this was from SAra E and then SAra H edited it in QGIS
# raw_polys_to_add <- st_read("data/published/data/data_updates/fulcrum/update_20240829/fromSaraE/newpolys_to_add.geojson")

# polygon_dupes <- st_drop_geometry(poly) |> 
#   group_by(site_id) |> 
#   summarise(count = n(),
#             dupe_name = toString(site_name)) |> 
#   filter(count > 1)
# 
# polygon_dupes_sh <- st_drop_geometry(site_poly_fulcrum_sh) |> 
#   group_by(site_id) |> 
#   summarise(count = n(),
#             dupe_name = toString(site_name))|> 
#   filter(count > 1)
# 
# new_polygon <- poly |> 
#   rbind(raw_polys_to_add) |> 
#   mutate(site_id = ifelse(site_name == "Boyd Park", 598798, site_id))


# new_polygon <- clgeo_Clean(new_polygon_temp)
# 
# ### existing data to compare
# # act_current <- st_read("data/published/data/hap_act_points_20240201.geojson")
# poly_current <- st_read("data/published/website/hap/public/assets/hap_site_poly_20240619.geojson")
point_current <- st_read("data/published/data/hap_site_points_20240913.geojson")
# point_current_website <- st_read("data/published/website/hap/public/assets/hap_site_points_20240625.geojson")


### import tide gauges to get closest station to each site
tide_gauge <- st_read("data/published/data/hap_tide_current_stations.geojson") |> 
  select(station_name, tide_url)

# max_site_id <- 4314184
num_na_rows <- site_points_fulcrum |> 
  filter(is.na(site_id)) %>%
  nrow()
 ### if there are rows with no site_id, make them 1 more than the max

### identify data points to remove
remove <- st_drop_geometry(site_points_fulcrum) |> 
  filter(status == "remove site") |> 
  select(site_id)

## select the necessary columns
updated_site_points_temp <- site_points_fulcrum |> 
  select(status, fulcrum_id, site_id, activity_codes, access_id_list, site_name, site_label, site_address, site_description, hours_info, open_close_date, fee, 
         public_transit, public_transit_description, url_public, site_manager, phone_site_manager, email_site_manager, 
         accessibility_description, safety, use_limits, program_yn, program_name, program_description, program_url, 
         program_contact, amenities_description, restrooms, changing_station, food, drinking_water, walking_trails, 
         equipment_rental, boat_launch_yn, bike_path_accessible, parking, parking_description, wheelchair_access_restrooms, 
         wheelchair_access_trails, swim_yn, fish_yn, hpbl_yn, mpbl_yn, boat_cleaning_requirements, site_name_photo_01, 
         site_name_photo_02, site_name_photo_03, photo_credits, owner, owner_type, water_quality_monitoring, typology, 
         notes, site_index, near_cso, latitude, longitude, ferry_landing) |>
  mutate(site_id = ifelse(is.na(site_id), max_site_id + row_number(), site_id)) |> 
  anti_join(remove) |> 
  mutate(site_name_photo_01 = ifelse(site_id == 6, "great_kills_park_01.jpg", site_name_photo_01),
         site_name_photo_02 = ifelse(site_id == 6, "great_kills_park_02.jpg", site_name_photo_02)) 

updated_act_points <- act_points_fulcrum |> 
  filter(!fulcrum_id == "60c950ba-cb3f-4962-95c4-d8099d283244") |> # remove swimming activity from Parelli Park
  select(fulcrum_parent_id, act_id, access_id, activity_site_id, access_name, activity, latitude, longitude, geometry) |> 
  rename(fulcrum_id = fulcrum_parent_id,
         act_lon = longitude,
         act_lat = latitude) |> 
  filter(!is.na(activity)) |> 
  left_join(st_drop_geometry(updated_site_points_temp[, c("fulcrum_id", "site_id", "site_name")]), by = "fulcrum_id") |> 
  mutate(activity_site_id = site_id,
         activity_site_name = site_name) |> 
  select(act_id, access_id, activity_site_id, activity_site_name, access_name, activity, act_lat, act_lon, geometry) |> 
  mutate(activity_site_name = trimws(activity_site_name, which = "both"),
         access_name = trimws(access_name, which = "both"), 
         access_name = ifelse(access_name == activity_site_name, NA, access_name)) |> 
  filter(activity_site_id != 418578) |> 
  select(activity_site_id, activity_site_name, access_name, activity, geometry) 

# site_id is used in too many places around the website to change the name to activity_site_id, so keep two copies, one with
# activity_site_id to update Fulcrum and one with site_id for the website
website_updated_act_points <- updated_act_points |> 
  rename(site_id = activity_site_id)

site_act_codes <- st_drop_geometry(updated_act_points) |> 
  select(activity_site_id, activity) |> 
  distinct() |> 
  group_by(activity_site_id) |> 
  summarise(act_codes_new = toString(activity)) |> 
  mutate(act_codes_new = gsub(" ", "", act_codes_new)) |> 
  rename(site_id = activity_site_id) 

updated_site_points <- updated_site_points_temp |> 
  select(-fulcrum_id) |> 
  left_join(site_act_codes, by = "site_id") |> 
  mutate(activity_codes = act_codes_new,
         site_name = str_to_title(site_name)) |> 
  select(-act_codes_new) |> 
  st_join(tide_gauge, join = st_nearest_feature) ### adding the name and url for closest tide gauuge

# dupes <- st_drop_geometry(updated_site_points) |> 
#   group_by(site_id) |> 
#   summarise(count = n())


### new poly check 
new_poly_check <- site_poly_fulcrum |>
  rename(site_name_poly = site_name) |>
  st_join(updated_site_points[, c("site_id", "site_name", "geometry")])



#### check polygon to make sure they are polys for all points

# poly_to_check <- new_polygon |> 
#   rename(site_name_poly = site_name) |>
#   # select(-site_name) |>
#   right_join(st_drop_geometry(updated_site_points[, c("site_id", "site_name")]), by = "site_id") |> ## change this to full_join to test, right join for final
#   select(site_id, site_name, site_name_poly, near_cso, geometry) 
# 
# poly_check <- st_drop_geometry(poly_to_check) |> 
#   rename(site_name_poly = site_name)
# 
new_poly_check <- st_drop_geometry(site_poly_fulcrum) |>
  rename(site_name_poly = site_name)
# 
# 
# #### THESE ARE THE sites with no polygon
point_poly_check <- updated_site_points |>
  select(site_id, site_name) |>
  full_join(new_poly_check, by = "site_id") |>
  filter(is.na(site_name_poly)) 

# |> 
#   select(-site_name_poly, -near_cso) |> 
#   st_join(site_poly_fulcrum) |> 
#   select(site_id.x, site_id.y) |> 
#   rename(site_id = site_id.x,
#          site_id_poly = site_id.y) |> 
#   st_drop_geometry() ### now I'll change site_id 

# ### if there are any missing polygons --- write out data for Sara to check and add polygons
# st_write(updated_act_points, "data/published/data/data_updates/fulcrum/update_20240829/forSaraE_toAddPoly/hap_act_points_TEMP_20240829.geojson")
# st_write(updated_site_points, "data/published/data/data_updates/fulcrum/update_20240829/forSaraE_toAddPoly/hap_site_points_TEMP_20240829.geojson")
# st_write(point_poly_check, "data/published/data/data_updates/fulcrum/update_20240829/forSaraE_toAddPoly/no_poly_20240829_update.geojson")
# st_write(site_poly_fulcrum, "data/published/data/data_updates/fulcrum/update_20240829/forSaraE_toAddPoly/current_poly.geojson")


### write out the data 
st_write(updated_site_points, "data/published/data/hap_site_points_20241011.geojson")
st_write(updated_site_points, "data/published/website/hap/public/assets/hap_site_points_20241011.geojson")
# st_write(new_polygon, "data/published/data/hap_site_poly_20241011.geojson")
# st_write(new_polygon, "data/published/website/hap/public/assets/hap_site_poly_20241011.geojson")
st_write(updated_act_points, "data/published/data/hap_act_points_20241011_FULCRUM_FORMATTED.geojson")
st_write(website_updated_act_points, "data/published/website/hap/public/assets/hap_act_points_20241011.geojson")

