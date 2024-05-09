library(sf)
library(tidyverse)



site_points_fulcrum_raw <- st_read("data/published/data/data_updates/fulcrum/hap.geojson") |> 
  rename(parking_description = parking_descripton,
         site_address = site_address_full)

new <- site_points_fulcrum_raw |> 
  filter(version > 1) |> 
  select(site_id, act_codes, access_id,              
         site_name, site_label, site_address,                
         site_description, hours_info, open_close_date,             
         fee, public_transit, public_transit_description,  
         url_public, site_manager, phone_site_manager,          
         email_site_manager, accessibility_description, safety,                      
         use_limits, program_yn, program_name,                
         program_description, program_url, program_contact,             
         amenities_description, restrooms, changing_station,            
         food, drinking_water, walking_trails,              
         equipment_rental, boat_launch_yn, bike_path_accessible,        
         parking, parking_description, wheelchair_access_restrooms, 
         wheelchair_access_trails, swim_yn, fish_yn,                     
         hpbl_yn, mpbl_yn, boat_cleaning_requirements,  
         site_name_photo_01, site_name_photo_02, site_name_photo_03,          
         photo_credits, owner, owner_type,                  
         water_quality_monitoring, typology, near_cso, cso_label,                  
         long, lat, geometry)

#### Also adding the program data and the ferry data
ferry <- read_csv("data/published/data/data_updates/fulcrum/hap_sites_name_program_contacts_ferry_5-9-24.csv") |> 
  select(site_id, program_contact, ferry_landing) |> 
  rename(program_update = program_contact) |> 
  distinct()

# poly <- st_read(, data/published/data/hap_site_polys_20230921.geojson, )
current_site_points <- st_read("data/published/data/hap_site_points_20240422.geojson") |> 
  rename(long = lon) |> 
  mutate(cso_label = NA) |> 
  distinct()
# act <- st_read(, data/published/data/hap_act_points_20230921.geojson, )

### determine which columns are missing
og_column_check <- janitor::compare_df_cols(new, current_site_points)

new_ids = as.list(new$site_id)

new_site_points <- current_site_points |> 
  filter(!site_id %in% new_ids) |> 
  rbind(new) |> 
  mutate(site_id = as.numeric(site_id)) |> 
  left_join(ferry, by = "site_id") |> 
  mutate(program_contact = program_update,
         public_transit_description = case_when(is.na(ferry_landing) ~ public_transit_description, 
                                                !is.na(ferry_landing) & !is.na(public_transit_description) ~ paste0(public_transit_description, ", Ferry: ", ferry_landing),
                                                !is.na(ferry_landing) & is.na(public_transit_description) ~ paste0("Ferry: ", ferry_landing)))


# transit <- st_drop_geometry(current_site_points) |> 
#   select(site_id, public_transit_description)
# 
# transit_new <- st_drop_geometry(new_site_points) |> 
#   select(site_id, public_transit_description) |> 
#   rename(new_public_transit_description = public_transit_description) |> 
#   left_join(transit, by = "site_id")

# site_points <- st_as_sf(point, coords = c(, lon, , , lat, ), crs=4326) |> 
#   mutate(lon = unlist(map(geometry,1)),
#          lat = unlist(map(geometry,2)),
#          near_cso = ifelse(near_cso == , 1, , , Y, , near_cso))

st_write(new_site_points, "data/published/data/hap_site_points_20240509.geojson" )
st_write(new_site_points, "data/published/website/hap/public/assets/hap_site_points_20240509.geojson" )



