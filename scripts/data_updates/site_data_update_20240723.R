library(sf)
library(tidyverse)

site_points_fulcrum <- st_read("data/published/data/data_updates/fulcrum/update_20240723/hap_site_points_fulcrum_export_7-23-2024.geojson")

act_points_fulcrum <- st_read("data/published/data/data_updates/fulcrum/update_20240723/hap_act_points_fulcrum_export_7-23-2024.geojson")
# 
site_poly_fulcrum<- st_read("data/published/website/hap/public/assets/hap_site_poly_20240619.geojson")
# 
# ### existing data to compare
# # act_current <- st_read("data/published/data/hap_act_points_20240201.geojson")
# poly_current <- st_read("data/published/website/hap/public/assets/hap_site_poly_20240619.geojson")
point_current <- st_read("data/published/data/hap_site_points_20240623.geojson")
point_current_website <- st_read("data/published/website/hap/public/assets/hap_site_points_20240625.geojson")


### import tide gauges to get closest station to each site
tide_gauge <- st_read("data/published/data/hap_tide_current_stations.geojson") |> 
  select(station_name, tide_url)

max_site_id <- 4313409
num_na_rows <- site_points_fulcrum |> 
  filter(any(is.na(site_id))) %>%
  nrow()
 ### if there are rows with no site_id, make them 1 more than the max

## select the necessary columns
updated_site_points_temp <- site_points_fulcrum |> 
  select(fulcrum_id, site_id, activity_codes, access_id_list, site_name, site_label, site_address, site_description, hours_info, open_close_date, fee, 
         public_transit, public_transit_description, url_public, site_manager, phone_site_manager, email_site_manager, 
         accessibility_description, safety, use_limits, program_yn, program_name, program_description, program_url, 
         program_contact, amenities_description, restrooms, changing_station, food, drinking_water, walking_trails, 
         equipment_rental, boat_launch_yn, bike_path_accessible, parking, parking_description, wheelchair_access_restrooms, 
         wheelchair_access_trails, swim_yn, fish_yn, hpbl_yn, mpbl_yn, boat_cleaning_requirements, site_name_photo_01, 
         site_name_photo_02, site_name_photo_03, photo_credits, owner, owner_type, water_quality_monitoring, typology, 
         notes, site_index, near_cso, latitude, longitude, ferry_landing) |>
  mutate(site_id = ifelse(is.na(site_id), max_site_id + row_number(), site_id))

updated_act_points <- act_points_fulcrum |> 
  ### this is fixing some site with blank acitivity, I have made this value required so it won't happen again
  mutate(activity = case_when(OBJECTID == 100 ~ "HPBL",
                                      OBJECTID == 187 ~ "FISH",
                                      TRUE ~ activity)) |> 
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
  mutate(activity_codes = act_codes_new) |> 
  select(-act_codes_new) |> 
  st_join(tide_gauge, join = st_nearest_feature) ### adding the name and url for closest tide gauuge

### write out data for Sara to check and add polygons
st_write(updated_act_points, "data/published/data/data_updates/fulcrum/update_20240723/forSaraE_toAddPoly/hap_act_points_TEMP_20240723.geojson")
st_write(updated_site_points, "data/published/data/data_updates/fulcrum/update_20240723/forSaraE_toAddPoly/hap_site_points_TEMP_20240723.geojson")
st_write(point_poly_check, "data/published/data/data_updates/fulcrum/update_20240723/forSaraE_toAddPoly/no_poly_20240723_update.geojson")
st_write(site_poly_fulcrum, "data/published/data/data_updates/fulcrum/update_20240723/forSaraE_toAddPoly/current_poly.geojson")

### Now import to finalize and push to website

#### check polygon to make sure they are polys for all points

updated_poly <- site_poly_fulcrum |> 
  select(-site_name) |> 
  inner_join(st_drop_geometry(updated_site_points[, c("site_id", "site_name")]), by = "site_id") |> ## change this to left_join to test
  select(site_id, site_name, near_cso, geometry) 

# st_write(updated_site_points, "data/published/data/hap_site_points_20240623.geojson")
# st_write(updated_site_points, "data/published/website/hap/public/assets/hap_site_points_20240623.geojson")
# st_write(updated_poly, "data/published/data/hap_site_poly_20240619.geojson")
# st_write(updated_poly, "data/published/website/hap/public/assets/hap_site_poly_20240619.geojson")
# st_write(updated_act_points, "data/published/data/hap_act_points_20240619.geojson")
# st_write(website_updated_act_points, "data/published/website/hap/public/assets/hap_act_points_20240619.geojson")

poly_check <- st_drop_geometry(updated_poly) |> 
  rename(site_name_poly = site_name)
  

point_poly_check <- updated_site_points |> 
  select(site_id, site_name) |> 
  full_join(poly_check, by = "site_id") |> 
  filter(is.na(site_name_poly))


