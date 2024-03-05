#### This script is for updating site points dataset so that it has fewer, and more manageable columns

# took the old site points, created a spreadsheet with column names for Sara E & Sara H to remove
# import the column removal list
# combine data from some columns so that we don't lose data
# remove unnecessary columns
# add column for csos and ms4s
# write out to test

library(sf)
library(tidyverse)


# add existing data
site_points <- st_read("data/published/data/hap_site_points_20240201.geojson")
poly <- st_read("~/Documents/spatial/SAVI/hudson_access/data/published/data/hap_site_polys_20240201.geojson")

column_names <- colnames(site_points)

# Create dataframe with column names
column_names_df <- data.frame(Column_Names = column_names)

write_csv(column_names_df, "data/temp/site_points_column_names.csv")


### import columns that we want to keep
columns <- read_csv("data/temp/HAP_tracking_matrix - site data updates - 2_29_2024.csv") |> 
  filter(`keep?` == "y") |> 
  select(Column_Names)

### create ms4 column to join 

cso_data <- st_drop_geometry(poly) |> 
  select(site_id, ms4, cso, nr_ms4_cso) |> 
  mutate(ms4 = ifelse(ms4 == 1, "Y", ms4),
         cso = ifelse(cso == 1, "Y", cso),
         nr_ms4_cso = ifelse(nr_ms4_cso == "Site within 1/2 mile of ms4 or CSO outfall", "Y", nr_ms4_cso))

# |> 
#   mutate(nr_ms4_cso = ifelse(is.na(nr_ms4_cso), NA, 1))

### now look at existing data to combine columns that we will remove and select columns to keep

new_site_points <- site_points |> 
  mutate(across(access_type_other, ~ ifelse(str_detect(.x, "Subway"), NA, .x))) |> 
  mutate(across(typology, ~ ifelse(str_detect(.x, "nyc wa"), NA, .x))) |> 
  mutate(access_type = ifelse(access_type == "other", NA, access_type),
         typology = ifelse(typology == "c,", NA, typology),
         typology = ifelse(typology == "c", NA, typology),
         typology = str_replace(typology, ",,", ", ")) |> 
  mutate(typology = ifelse(is.na(typology), access_type, typology),
         typology = ifelse(is.na(typology), access_type_other, typology),
         typology = ifelse(site_id == 900154, "Street End", typology),
         typology = gsub(",\\s*$", "", typology),
         typology = sub("(\\w)(.*)", "\\U\\1\\E\\2", typology, perl = TRUE),
         typology = gsub(",", ", ", typology),
         typology = gsub(",  ", ", ", typology),
         safety = ifelse(!is.na(safety_HPBL), paste(safety, ", Human-powered boating safety: ", safety_HPBL), safety),
         safety = ifelse(!is.na(safety_SWIM), paste(safety, ", Swimming safety: ", safety_SWIM), safety),
         safety = gsub("NA , ", "", safety),
         parking_description = ifelse(str_detect(distance_parking_to_launch_HPBL, "ft"), 
                                      paste(parking_description, ", approximately ", distance_parking_to_launch_HPBL, " to boat launch from parking"), 
                                      parking_description),
         boat_cleaning_requirements = NA) |> 
  left_join(cso_data, by = "site_id") |> 
  select(site_id, act_codes, access_id, site_name, site_label, site_address, site_description, hours_info, open_close_date, fee, 
         public_transit, public_transit_description, url_public, site_manager, phone_site_manager, email_site_manager, 
         accessibility_description, safety, use_limits, program_YN, program_name, program_description, program_url, 
         program_contact, amenities_description, restrooms, changing_station, food, drinking_water, walking_trails, 
         equipment_rental, boat_launch_YN, bike_path_accessible, parking, parking_description, wheelchair_access_restrooms, 
         wheelchair_access_trails, SWIM_YN, FISH_YN, HPBL_YN, MPBL_YN, boat_cleaning_requirements, site_name_photo_01, 
         site_name_photo_02, site_name_photo_03, photo_credits, owner, owner_type, water_quality_monitoring, typology, 
         ms4, cso, lat, lon) 
  

write_sf(new_site_points, "data/published/data/hap_site_points_20240304.geojson")
