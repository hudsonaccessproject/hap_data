#### tide and current data

library(sf)
library(tidyverse)


raw_tide <- st_read("data/raw/water_safety/NOAA_tide_current_prediction_stations_HAP102023.geojson")
raw_temp <- st_read("data/raw/water_safety/NOAA_water_temp_stations_HAP102023.geojson")


  temp <- raw_temp |> 
    select(id, name, station_URL) |> 
    rename(temp_url = station_URL,
           station_name = name) |> 
    mutate(station_type = "Temperature Station",
           current_url = NA,
           tide_url = NA) |> 
    select(station_type, station_name, tide_url, current_url, temp_url, geometry)
  
  tide <- raw_tide |> 
    filter(hap_extent == "hap") |>
    select(ID, Name, NOAA.tide.gauge.location, station_type, NOAA_station_chart_url, hap_extent) |> 
    mutate(Name = ifelse(is.na(Name), NOAA.tide.gauge.location, Name)) |> 
    rename(id = ID,
           station_name = Name,
           station_url = NOAA_station_chart_url) |> 
    select(id, station_name, station_type, station_url, geometry) |> 
    separate(station_name, into = c("station_name", "depth"), sep =" \\(Depth") |> 
    arrange(station_name, depth) 
  
  tide_grouped <- tide |> 
    st_drop_geometry() |> 
    group_by(id) |> 
    summarise(station_name = first(station_name),
              station_type = first(station_type),
              station_url = first(station_url))  |> 
    select(-id) |> 
    pivot_wider(
      id_cols = "station_name",
      names_from = station_type,
      values_from = "station_url"
    ) |> 
    mutate(station_type = case_when(is.na(tide) ~ "Current Prediction Station", 
                                    is.na(Current) ~ "Tide Prediction Station",
                                    TRUE ~ "Tide & Current Prediction Station")) |> 
    rename(tide_url = tide,
           current_url = Current) |> 
    mutate(temp_url = NA) |> 
    select(station_type, station_name, tide_url, current_url, temp_url)
  
  tide_sf <- tide |> 
    filter(station_type == "tide") |> 
    select(station_name, geometry) |> 
    left_join(tide_grouped, by = "station_name") |> 
    select(station_type, station_name, tide_url, current_url, temp_url)
  
  current_sf <- tide |> 
    filter(station_type == "Current") |> 
    group_by(id) |> 
    summarise(station_name = first(station_name),
              geometry = first(geometry)) |> 
    select(station_name, geometry) |> 
    left_join(tide_grouped, by = "station_name") |> 
    filter(station_type != "Tide & Current Prediction Station") |> 
    select(station_type, station_name, tide_url, current_url, temp_url)
  
  stations <- tide_sf |> 
    rbind(current_sf) |> 
    rbind(temp) 

# st_write(tide_sf, "data/published/data/hap_tide_current_stations.geojson")
# 
# st_write(temp, "data/published/data/hap_temp_stations.geojson")

st_write(stations, "data/published/data/hap_noaa_stations.geojson")

