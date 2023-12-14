#### tide and current data

library(sf)
library(tidyverse)


raw_tide <- st_read("data/raw/water_safety/NOAA_tide_current_prediction_stations_HAP102023.geojson")
raw_temp <- st_read("data/raw/water_safety/NOAA_water_temp_stations_HAP102023.geojson")


temp <- raw_temp |> 
  select(id, name, lat, lng, station_URL)

tide <- raw_tide |> 
  filter(hap_extent == "hap") |>
  select(ID, Name, NOAA.tide.gauge.location, station_type, NOAA_station_chart_url, hap_extent) |> 
  mutate(Name = ifelse(is.na(Name), NOAA.tide.gauge.location, Name)) |> 
  rename(id = ID,
         station_name = Name) |> 
  select(id, station_name, station_type, geometry)

st_write(tide, "data/published/data/hap_tide_current_stations.geojson")

st_write(temp, "data/published/data/hap_temp_stations.geojson")

# bird_grid <- st_read(filepath here)
# 
birds <- st_drop_geometry(bird_grid) |>
  group_by(GRID_ID) |>
  summarize(birds = toString(COMMON_NAME))
# 
# # Group by 'GRID_ID' and concatenate 'COMMON_NAME' values into a string
# birds = all_birds.groupby('GRID_ID')['COMMON_NAME'].apply(lambda x: ', '.join(x)).reset_index(name='birds')
